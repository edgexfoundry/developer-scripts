#!/usr/bin/python3

import os, sys
import subprocess
import requests

# Retrieve the git log of the current directory with line change stats (except renames and type changes)
GIT_LOG_CMD = ['git', 'log', '--pretty=format:%aI%x20%aN%x20%ae', '--diff-filter=rt', '--numstat']
#print(' '.join(GIT_LOG_CMD))

GITHUB_ACCESS_TOKEN = os.environ.get('GITHUB_ACCESS_TOKEN', '')
GITHUB_ISSUES_URL = 'https://api.github.com/repos/edgexfoundry/%(repo)s/issues?state=all&access_token=%(access_token)s&since=%(since)s&page=%(page)s'

stats = 0
commits = 0
authors = dict()
old_authors = set()
repos = set()
issues_opened = 0
issues_closed = 0

basedir = os.getcwd()

from_date = sys.argv[1]
to_date = sys.argv[2]
#print('From: %s\tTo: %s' % (from_date, to_date))

# Iterate through every local repo passed as a command-line argument
for repo in sys.argv[3:]:

    repo_name = repo.split('/')[-1]
    issues_page = 1
    while (issues_page):
        repo_issues_url = GITHUB_ISSUES_URL % {'repo': repo_name, 'since': from_date, 'page': issues_page, 'access_token': GITHUB_ACCESS_TOKEN}
        #print('Calling: %s' % repo_issues_url)
        resp = requests.get(repo_issues_url)
        if resp.status_code == 200:
            issues = resp.json()
            for issue in issues:
                created = issue['created_at'][:10]
                if created >= from_date and created <= to_date:
                    issues_opened += 1
                if issue['state'] == 'closed':
                    closed  = issue['closed_at'][:10]
                    if closed >= from_date and closed <= to_date:
                        issues_closed += 1
        if 'link' in resp.headers and 'rel="next"' in resp.headers['link']:
            issues_page+= 1
        else:
            break

    os.chdir(os.path.join(basedir, repo))
    log = os.popen(' '.join(GIT_LOG_CMD))

    date = None
    for line in log:
      args = line.split()
      if len(args) > 2 and len(args[0]) == 25:
          date = args[0][:10]
          if date >= from_date and date <= to_date:
              commits += 1
              repos.add(repo)

              email = args[-1]
              author = ' '.join(args[1:-1])
              if email not in authors or len(author) > len(authors[email]):
                  authors[email] = author
          elif date <= from_date:
              email = args[-1]
              old_authors.add(email)

      elif len(args) == 3:
          if date is not None and date >= from_date and date <= to_date:
              if args[2].startswith('vendor'):
                  continue
              try:
                  added = abs(int(args[0]))
                  removed = abs(int(args[1]))
                  stats += max(added, removed)# the larger value
              except ValueError:
                  pass

print('%d Active Repos' % len(repos))
print('%d Issues Opened' % issues_opened)
print('%d Issues Closed' % issues_closed)
print('%d Commits' % commits)
print('%d Lines of code' % stats)
print('%d Authors' % len(authors))
print('%d New Authors' % len(authors.keys() - old_authors))
for email in sorted(authors, key=lambda e: authors.get(e).lower()):
    if email in old_authors:
        print('%s <%s>' % (authors[email], email))
    else:
        print('**%s** <%s>' % (authors[email], email))




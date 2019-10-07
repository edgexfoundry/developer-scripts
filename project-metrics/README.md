
## Fetch repos

Scripts that generate Git statistics use a local checkout of EdgeX git repos. Before you run those scripts, you will need to fetch the latest contents from Github.  To do that, run:

```
./fetch_repos.sh
```

This will create a local ./repos folder with a checkout of all the EdgeX repositories from Github.

## Release Statistics

The Release Notes document should include Git and Github statistics. To create those run:

```
./release_metrics.py <YYYY-MM> <YYYY-MM> ./repos/*
```

Where the first YYYY-MM is the beginning month of the release cycle, and the second YYYY-MM is the ending month.

(Tip: To generate statistics for just one repo, specify it as the last parameter instead of ./repos/*)

(Tip: If you run this more than once, you'll need to get an access token from Github and set it to the environment variable GITHUB_ACCESS_TOKEN)

## Dockerhub stats

This script will report download numbers for every Docker image in the edgexfoundry organization:

```
./dockerhub-downloads.py
```
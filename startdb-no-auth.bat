@ECHO off
SET dbpath="C:\Users\Public\mongodb\db"
if not exist %dbpath% (
  echo %dbpath% directory does not exist. Creating...
  mkdir %dbpath%
  echo off
)
  
start "" "C:\Program Files\MongoDB\Server\3.6\bin\mongod.exe" --dbpath %dbpath%
GOTO END

:END
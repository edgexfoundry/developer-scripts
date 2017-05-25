:PUBLIC
@ECHO PUBLIC PATH
start "" "C:\Program Files\MongoDB\Server\3.0\bin\mongod.exe" --dbpath "C:\Users\Public\mongodb\db" --auth
GOTO END

:END
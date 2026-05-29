## proof of concept

small project to check out dotnet selenium testing inside a nix dev shell build

to update nuget deps

```
$ dotnet restore --packages out

```
```
$ nuget-to-json out > nuget-deps.json

```

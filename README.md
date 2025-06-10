# Library.Template

This is a template for a .Net library project. The main idea is to provide convenient preconfigured project structure that would utilize [Github Flow](https://docs.github.com/en/get-started/quickstart/github-flow) for development process and [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for semantic versioning and generating a change log.

## Features

* GitHub Actions
  * When PR is opened, run tests and lint commit messages for [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standards
  * When PR is merged, run tests, publish to NuGet, update the changelog file and create GitHub release while using [GitVersion](https://gitversion.net/) to figure out the next version. GitVersion is configured to use Conventional Commits to figure out the next release version.
* Preconfigured [StyleCop](https://github.com/StyleCop/StyleCop) rules
* [Pre-Commit](https://pre-commit.com/) configuration and scripts to install the tool and it's hooks
* Scripts to install dependencies so development can be started quicker
* Sample Guard utility class for validation

## Prerequisites

* [.NET SDK](https://dotnet.microsoft.com/) as defined in `global.json`
* PowerShell on Windows for running the helper scripts
* [Python](https://www.python.org/) for installing and running `pre-commit`

## How to start development with this template?

1. Create a GitHub repository with this project as its template
2. Run ``install-dependencies`` (`.ps1` on Windows or `.sh` on Linux). It installs the right .NET SDK, `dotnet-format` and sets up `pre-commit`
3. Create a [NuGet API key](https://docs.microsoft.com/en-us/nuget/nuget-org/publish-a-package#create-api-keys) and set it in the repository ``secrets`` as ``NUGET_TOKEN``
4. Replace `COMPANY-PLACEHOLDER` in ``stylecop.json`` with your company or project name
5. Replace `COMPANY-PLACEHOLDER` values in ``Directory.Build.props`` with the same value
6. If you use a different strong name key, update ``strongname.snk`` and ``AssemblyInfo.cs`` accordingly

## Publishing a package manually

For testing you may want to publish the package without waiting for the merge workflow. Pack and push the project manually:

```bash
dotnet pack -c Release
dotnet nuget push "bin/Packages/Release/*.nupkg" -k <API_KEY> -s https://api.nuget.org/v3/index.json
```

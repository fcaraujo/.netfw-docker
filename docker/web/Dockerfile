# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build-stage

RUN nuget update -self

WORKDIR /src/OldWebApi
COPY src/OldWebApi/packages.config .
RUN nuget restore packages.config -PackagesDirectory ../../packages

COPY src/ /src

RUN msbuild OldWebApi.csproj `
    /p:OutputPath=/out `
    /p:DeployOnBuild=true

RUN dir /out/_PublishedWebsites/OldWebApi

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8
SHELL [ "powershell" ]

RUN Remove-Item -Recurse 'C:\inetpub\wwwroot\*'
WORKDIR /inetpub/wwwroot

COPY --from=build-stage /out/_PublishedWebsites/OldWebApi /inetpub/wwwroot/web-api

RUN Remove-Website -Name 'Default Web Site'; `
    New-Website -Name 'Old Web Api' -Port 80 -PhysicalPath 'c:\inetpub\wwwroot\web-api'


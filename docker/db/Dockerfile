#escape=`
# ARG AcceptEula='Y'
ARG DataPath='c:\data'
ARG OutputPath='c:\output'
# ARG SaPwd='TempD0cker!Pwd!!'
ARG SQLProject='Old.Database'
ARG SSDTPath='c:\Microsoft.Data.Tools.Msbuild\lib\net46'

FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build-stage

ARG OutputPath
ARG SQLProject
ARG SSDTPath
ENV SQLDBExtensionsRefPath ${SSDTPath}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN nuget install Microsoft.Data.Tools.Msbuild -Version 10.0.61804.210 -ExcludeVersion

WORKDIR /src/${SQLProject}
COPY src/${SQLProject} .

RUN msbuild ${SQLProject}.sqlproj /p:OutputPath=${env:OutputPath}

FROM microsoft/mssql-server-windows-express

ARG DataPath
ARG OutputPath
ARG SSDTPath

ENV OutputPath=${OutputPath} `
    SSDTPath=${SSDTPath}

COPY --from=build-stage ${OutputPath} ${OutputPath}
COPY --from=build-stage ${SSDTPath} ${SSDTPath}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN $env:PATH = ${env:SSDTPath} + ';' + ${env:PATH}; `
    [Environment]::SetEnvironmentVariable('PATH', ${env:PATH}, [EnvironmentVariableTarget]::Machine)

# TODO: assign values in dockercompose 
ENV ACCEPT_EULA='Y' `
    DATA_PATH='c:\data' `
    SA_PASSWORD='TempD0ckerPwd!!'
# - attach_dbs=[{"dbName":"myDB","dbFiles"["c:\\db\\DB_Data.MDF","c:\\db\\DB_Log.LDF"]}]

VOLUME ${DataPath}

WORKDIR /init
COPY docker/db/start.ps1 .

CMD ./start.ps1 -SA_PASSWORD ${env:SA_PASSWORD} -ACCEPT_EULA ${env:ACCEPT_EULA} -attach_dbs \"${attach_dbs}\" -Verbose
# CMD ["powershell"]

#https://blogs.msdn.microsoft.com/heaths/2017/09/18/installing-build-tools-for-visual-studio-2017-in-a-docker-container/
#https://github.com/docker/labs/blob/master/windows/sql-server/part-1.md
FROM microsoft/windowsservercore
SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

RUN Set-ExecutionPolicy Bypass -Scope Process -Force; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install microsoft-build-tools -y

RUN choco install dotnet4.6.1 -y

RUN choco install netfx-4.6.1-devpack -y

RUN choco install nuget.commandline -y

RUN nuget install Microsoft.Data.Tools.Msbuild

ENV MSBUILD_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin" \
    DATATOOLS_PATH="C:\Microsoft.Data.Tools.Msbuild.10.0.61710.120\lib\net46"

RUN $env:PATH = $env:DATATOOLS_PATH + ';' + $env:MSBUILD_PATH + ';' + $env:PATH; \
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

RUN setx SQLDBExtensionsRefPath $env:DATATOOLS_PATH /M

RUN setx SSDTPath $env:DATATOOLS_PATH /M



# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY BlazorServerApp/*.csproj ./BlazorServerApp/
RUN dotnet restore

# copy everything else and build app
COPY BlazorServerApp/. ./BlazorServerApp/
WORKDIR /source/BlazorServerApp
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "BlazorServerApp.dll"]
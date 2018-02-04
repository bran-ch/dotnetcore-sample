# Create a container with the compiled asp.net core app
# This file is needed only if you plan to package the app as a container in your CI process
#FROM microsoft/aspnetcore:2.0

# Create app directory
#WORKDIR /app

# Copy files from the artifact staging folder on agent
#COPY dotnetcore-sample/out/dotnetcore-sample .

#ENTRYPOINT ["dotnet", "dotnetcore-sample.dll"]

FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app

# copy csproj and restore as distinct layers
COPY dotnetcore-sample/*.csproj ./
RUN dotnet restore

# copy everything else and build
COPY dotnetcore-sample/* ./
RUN dotnet publish -c Release -o out

# build runtime image
FROM microsoft/aspnetcore:2.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "dotnetcore-sample.dll"]

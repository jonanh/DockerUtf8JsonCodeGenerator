FROM microsoft/dotnet:2.0-sdk AS build-env
WORKDIR /app

ARG SOURCE="https://github.com/neuecc/Utf8Json/archive/v1.3.7.zip"

RUN apt-get update
RUN apt-get install -qqy \
      wget \
      unzip

RUN echo "Downloading project file" \
 && wget --quiet "${SOURCE}"

RUN unzip *.zip

WORKDIR src/Utf8Json.UniversalCodeGenerator

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out


# build runtime image
FROM microsoft/dotnet:2.0-runtime
WORKDIR /app
COPY --from=build-env /app/src/Utf8Json.UniversalCodeGenerator/out/ ./
ENTRYPOINT ["dotnet", "Utf8Json.UniversalCodeGenerator.dll"]


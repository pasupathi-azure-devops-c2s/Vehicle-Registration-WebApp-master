FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /WebAPI

COPY . ./

WORKDIR /

RUN dotnet restore

RUN dotnet publish -c Release -o /WebAPI/out

EXPOSE 7095

ENTRYPOINT [ "dotnet", "/WebAPI/out/VehicleRegistration_WebAPI.dll" ]



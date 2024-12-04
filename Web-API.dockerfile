
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

COPY . ./Vehicle-Web-App

RUN dotnet restore ./Vehicle-Web-App

RUN dotnet tool install --global dotnet-ef --version 9.0.0

ENV PATH="$PATH:/root/.dotnet/tools"

RUN dotnet ef database update --project ./Vehicle-Web-App/VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj

RUN dotnet publish ./Vehicle-Web-App/VehicleRegistration.WebAPI/VehicleRegistration.WebAPI.csproj --configuration Release --output /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

ENV ConnectionStrings__Default="Server=tcp:sqldbserver8199.database.windows.net,1433;Initial Catalog=ASP_NET_Database;Persist Security Info=False;User ID=Pasupathikumar;Password=NewPassword1234;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
ENV Jwt__Key="ab56ufuifywduwd76rGiri7H6uyfivbiNIOUGIUFriouhioud9p9"

COPY --from=build /app/publish /app
ENV ASPNETCORE_URLS=http://+:7095

WORKDIR /app
RUN dotnet dev-certs https --trust
EXPOSE 7095

ENTRYPOINT  ["dotnet", "VehicleRegistration.WebAPI.dll"]
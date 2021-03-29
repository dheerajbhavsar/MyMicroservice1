FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["MyMicroService1.csproj", "./"]
RUN dotnet restore "MyMicroService1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "MyMicroService1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyMicroService1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyMicroService1.dll"]

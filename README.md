

# How To Dockerize

## Database

### DB Project Builder

#### step 1 - create base builder image with MS Sql Server Data Tools

`
docker build -t ssdtbuild -f .\netfx-4.7.2-ssdt-Dockerfile .
`

#### step 2 - DB Project builder
Create a docker container that build the SQL Project. This image is built on top of netfx-4.7.2-ssdt-Dockerfile

`
docker image build -t mssql-builder -f .\MSSQL-builder-Dockerfile .
`

#### step 3 - run container

docker container run -d -P mssql-builder
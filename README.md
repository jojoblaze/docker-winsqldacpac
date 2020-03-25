

# How To Dockerize

## Database

### DB Project Builder

#### step 1 - create base image with MS Sql Server Data Tools

`
docker build -t ssdtbuild -f .\netfx-4.7.2-ssdt-Dockerfile .
`

#### step 2 - DB Project builder
Create a docker container that build the SQL Project. This image is built on top of netfx-4.7.2-ssdt-Dockerfile

`
docker image build -t mssql -f .\MSSQL-Dockerfile .
`

#### step 3 - run container

docker container run -d -P mssql


## Notes
MS-SQL docker image has strength password policy. Make sure to use a sa_password that respect that constraints to avoid login problems.
`
Example: ABCdef123!$%
`
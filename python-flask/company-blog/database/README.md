## Direct Run Official Image
1. run docker container    
    `docker container run -p 5432:5432 --name psql -e POSTGRES_PASSWORD=root -e POSTGRES_USER=postgres -v psql-db:/var/lib/postgresql/data -d postgres:12`  
2. `docker exec -it psql psql -U postgres`
  
## Custom Build Docker Image
1. run `docker image build -t psql_custom:12 .`  
2. `docker container run -p 5432:5432 --name psql -e POSTGRES_PASSWORD=root -e POSTGRES_USER=postgres -v psql-db:/var/lib/postgresql/data -d psql_custom:12`



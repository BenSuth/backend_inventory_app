# Shopify Backend Developer Intern Challenge - Summer 2022

This is my submission for the Shopify Backend Developer Intern Challenge - Summer 2022: https://www.shopify.ca/careers/backend-developer-intern-summer-2022-remote-us-canada_f29b717b-42d7-4d32-851b-e5b2c69a16c7

You can view / tryout the full stack application at: https://bensuth.github.io/frontend-inventory-app/

The front-end web application (React app) source code: https://github.com/BenSuth/frontend-inventory-app
Things you may want to cover:

## Requirements
- Ruby 3.0.3
- Rails ~> 7.0.1
- Postgres 12  

## Setup
- git clone https://github.com/BenSuth/backend_inventory_app.git
- cd backend_inventory_app
- bundle install (May need to run Bundle Update as well)
- rails db:setup 
  
  You may need to start postgres

  run sudo service postgresql start
  
  run sudo -u postgres createuser --superuser <Name>

- rails db:migrate
- (Optional) rails test
- rails server
  
## GraphiQL Playground
- Navigate to http://localhost:3000/graphiql
- This is a test environment for graphql end-points
- Only available in test environment (local server)

### Example Queries and Mutations
- Create a new item
 ```
mutation {
  createItem(input: {
    params: {
      name: "Sample Name"
      description: "Sample Description"
      count: 20
      tags: ["Sample", "List", "Tags"]
    }
  }) {
      item {
        id
        name
        description
        count
        tags
    }
  }
}
```
- Update an existing item
 ```
mutation {
  updateItem(input: {
    itemId: 1
  	params: {
      name: "Sample Name Update"
      description: "Sample Description Update"
      count: 20
      tags: ["Sample", "List", "Tags"]
    }
  }) {
      item {
        id
        name
        description
        count
        tags
    }
  }
}
```
- Delete an existing item
 ```
mutation {
  deleteItem(input: {
    itemId: 1
  }) {
      item {
        id
        name
        description
        count
        tags
    }
  }
}
```
  
- Fetch all items
 ```
query {
  fetchItems {
    id
    name
    count
    description
    tags
  }
}
```
  
- Fetch item by ID
 ```
query {
  fetchItem(itemId: 1) {
    id
    name
    count
    description
    tags
  }
}
```
- Create a new .csv file
```
mutation {
  createExport (input: {
    	params: {
        externalName: "SampleFileName"
      }
  }) {
    path
  }
}
```
- Fetch all .csv files
```
query {
  fetchExports {
    id
    externalName
    internalName
    path
    size
    fileType
  }
}
```
  
- Fetch .csv by ID
```
query {
  fetchExport(exportId:1) {
    id
    externalName
    internalName
    path
    size
    fileType
  }
}
```
  




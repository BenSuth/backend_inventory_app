# Shopify Backend Developer Intern Challenge - Summer 2022

This is my submission for the Shopify Backend Developer Intern Challenge - Summer 2022: https://www.shopify.ca/careers/backend-developer-intern-summer-2022-remote-us-canada_f29b717b-42d7-4d32-851b-e5b2c69a16c7

You can view / tryout the full stack application at: https://bensuth.github.io/frontend-inventory-app/

The front-end web application (React app) source code: https://github.com/BenSuth/frontend-inventory-app
Things you may want to cover:

## Requirements
- Ruby 3.0.3
- Rails ~> 7.0.1
- Postgres 12  

## Deployment
Backend - Heroku

Frontend - Github Pages

# Production Endpoint
Backend: https://ben-sutherland-inventory-app.herokuapp.com/graphql

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
## Requirement Implementation
### Create Inventory Items
- Graphql mutation, createItem, handles post requests with this mutation
- Post request must contain all required fields, such as name, count, etc.
- Creates a new entry in the Items table, and an associated tag in the Tags table
- Returns an error if validations on Item model are violated
### Update Inventory Items
- Graphql mutation, updateItem, handles post requests with this mutation
- Post request can contain some or all fields, such as name, count, etc.
- Post request must contain the ID of the item
- Finds and updates the table with the fields in the request body
- If tags field is present, it will propogate the changes to the associated Tag row in Tags table
- Each Item has_one Tag
- Returns an error if validations on Item model are violated
### Delete Inventory Items
- Graphql mutation, deleteItem, handles post requests with this mutation
- Post request must contain the ID of the item
- Finds the item in the Items table and deletes it, this is propogated to the associated tag in Tags table as well.
- If tags field is present, it will propogate the changes to the associated Tag row in Tags table
- All deletes of items are soft-deletes, the data persists in the Items/Tags table but the delete_dt column is updated
- All queries found in Item model filter out items with a delete_dt
### View Inventory Items
- Graphql queries, fetchItem and fetchItems, respond to post requests with these queries
- fetchItems will return all non-deleted items in the database
- fetchItem will return the item from the Items table with the specified itemId
### Export Data to a CSV
- Graphql mutation, createExport, handles post requests with this mutation
- In development / test environments, all storage is handled locally in /tmp/storage directory
- In production, the CSV generation is tied to an AWS S3 bucket.
- When createExport runs, it opens a new file stream to the S3 bucket,
  then writes the Item/Tag data from the tables into the file on the S3 bucket.
- It then stores the name, size, url in the Exports table
- This allows for great efficieny gains, as an end-user does not need to re-export old reports
- This also enables fetchExport and fetchExports (function identically to fetchItem and fetchItems queries)
  to retrieve data from the Exports table
- This AWS S3 bucket integration was done intentionally with how future files, images, pdfs, etc.
  features may be implemented.  These files generally should not be stored in a database, so having 
  an active storage solution will make future file type features easily integrateable.
  




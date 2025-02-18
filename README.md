# README

## STEPS TO RUN

* Pre-requisites

    * Docker Desktop
    * Docker Compose(docker-compose)

* Start Docker Desktop on your machine.

* Go to terminal and clone the code repo using ssh via command: 
    `git@github.com:mubashirkamran4/homeday.git`

* Switch to code repo via `cd homeday`

* Build the docker images:
   ```
     docker-compose build
   ```
* Start the containers:
    
    ```
        docker-compose up -d
    ```

* Go inside the container using:
    ```
        docker-compose exec web bash
    ```

* Open the browser and point URL to for instance `http://localhost:3000/properties/nearby?lat=52.5342963&lng=13.4236807&property_type=apartment&marketing_type=sell` and you would see the 25 properties as well as the meta tag that contains the current page, total pages and total number of records, therefore to go to the next page and fetch more properties just append `&page=2` and it would take to you to the next page and you can keep incrementing it till the last page displayed in meta tag. I assumed that this API would be used in some UI so we can definitely provide pagination and NEXT button for next pages.

* To execute the test cases:
    * go to `test` container via command: `docker-compose exec test bash`
    * run the command `rspec` and it will execute the test cases for our controller present inside `spec/controllers/properties_controller_spec.rb` files.

## Some Key Considerations

### Distance Calcuation

* We were dealing with geolocation over here, PostgreSQL provides very nice geolocation calculation module[https://www.postgresql.org/docs/current/earthdistance.html] earthdistance(as was provided in the docs as well), so I used cube based earth distance to calculate the distance between two given points in lat/lng format via `earth_distance(ll_to_earth(lat, lng), ll_to_earth(lat,lng))`, they on the backend use `cube` and `earthdistance` extensions. See `app/controllers/properties_controller.rb:8`


### Faster Queries

As we would have to deal with a lot of records for whole of Germany e.g., so it is imperative to make it faster, therefore I made use of following 2 approaches here:

* GIST Indexing on `ll_to_earth(lat, lng)` , which would create the boxes and would store the properties near to each other in the relevant boxes.

* Implementing pagination via `kaminari` gem, as I assumed that this API's result is going to be used somewhere in UI, so it would be nicer to paginate it and user can definitely see total pages, next page links to navigate.

* Lastly, just keeping User expereince in mind, I noticed many properties were not updated with proper addresses like they were missing zip_code, city, house_number or street. So we can instead show those properties first where we have complete details and then later with missing details on the last pages.



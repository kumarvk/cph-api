## cph-api
* Scrape all flight departures and arrival from Copenhagen Airport's website and import data into our pg database.
* Provide some API for getting departures and arrival details with filter.

## How to set up the project?
* Created ruby on rails api application with pg `rails new cph-api --api --database=postgresql`

## Dependencies
* Used `pg` gem as described in the requirement.
* Used `nokogiri` gem for scrapping.
* Used `rspec` for writing test cases.
* Used `kaminari` for pagination.
* Used `whenever` for cron job.
* Used `factory_bot_rails` for create active recored into testing enviourment.

## Application understanding
* Here we create a ryby on rails backend api application.
* Created API, get all filghts details as according to arrivals, departures.
* Created API for filteration as date and time, flights from/to a specific city, Flight number, Flight airline company and status.
* We need to use testing tool.

## Solution
* Just create a api based ruby on rails repo.
* Used single table inheritance applied `Flight` table.
* For scraping used `nokogiri` gem.
* Used `kaminari` gem for getting data according to page and each page contain 5 records.
* Used `whenever`gem for getting all records at every day from cph website through cron job.

## Installation
* Take clone of the repo:`git clone https://github.com/kumarvk/cph-api`

* Then `bundle install`

* For database do `rails db:create` and `rails db:migrate`

* Create log file for cron job `log/whenever.log`

* For test enviourment database do `rails db:migrate RAILS_ENV=test`

* For scraping `rails cph:flights`

* Run `rails s`

* Run test cases `rspec`

## Endpoints
* Get all dispatures flights.

  `GET  /api/flights/departures`
```
  params {
    page: 1 //its optional
  }
```
* Search departures flights.

  `GET /api/flights/departures/search`
```
  params {
    page: 1 // its optional
    text: "Test" // its optional
    time: "00:00" // its optional
    date: new Date() // its optional
  }
```
* Get all arrivals flights.

  `GET  /api/flights/arrivals`
```
  params {
    page: 1 // optional
  }
```
* Search departures flights.

  `GET  /api/flights/arrivals/search`
```
  params {
    page: 1 // optional
    text: "Test" // optional
    time: "00:00" //its optional
    date: new Date() //its optional
  }
```

## Note
* If you want to log of scrapping then see log file.
  `log/whenever.log`

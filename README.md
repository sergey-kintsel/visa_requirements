# Visa Requirements

This simple app allows you to find countries which you can visit
with your friends from different countries without ~~pain~~ visas or with eVisa.

## Installation

To run the app you need to:

  1. install Elixir and Mix

    ```bash
    brew install elixir
    mix local.hex
    ```

  2. install dependencies and compile the app

    ```bash
    mix deps.get
    mix escript.build
    ```
  
  3. run the app with necessary country codes separated by comma

    ```bash
    ./visa_requirements kz,ru,us
    ```

## Misc

Currently only Kazakhstan, Belarus, Poland, Bulgaria and Russia are supported as parameters

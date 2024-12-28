# whereisjeremy.live
Static [whereisjeremy.live](https://whereisjeremy.live) website. Because stalkers and spies need love too.

## Setup and test
```
gem install aws-sdk-secretsmanager
gem install rspec
cd /path/to/whereisjeremy.live/build
rspec
```

## Add a location
```
cd /path/to/whereisjeremy.live/cli
ruby add_location 2024-01-01 2024-01-09 City
```

## AWS Secrets Manager
Locations are stored in Secrets Manager. You know, for security, so I can publish them on a public website.

There are three secrets:

| Secret  | Expected Format |
| ------------- | ------------- |
| whereisjeremy-default-city | "City" |
| whereisjeremy-watch-city  | "City"  |
| whereisjeremy-locations | [["2021-05-03", "2021-06-09", "Portland"], ["2020-11-30", "2021-01-01", "Madrid"]] |

## Github Action
This Rube Goldberg machine keeps the site up to date:

1. Daily write to `timestamp.txt`
2. Causes `main` to update
3. Triggers an Amplify build
4. Pulls the latest location data from AWS Secrets Manager

## Subdomain redirect for `www`
See https://github.com/jmodjeska/modjeska.us for subdomain redirect config using Lambda@Edge, Cloudfront, and Route53.

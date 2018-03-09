---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - php
  - python
  - javascript

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the DataCue API! You can use our API to access DataCue API endpoints, which can get information on ***********

We have language bindings in Javascripy, PHP, and Python! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

# Headers

## Authentication

> To authorize, use this code:

```php
<?
$encode = base64_encode('API-key');
$auth = "Basic $encode";
?>
```

```python
import base64

auth = "Basic {}".format(base64.b64encode('API-key'))
```

```javascript
let auth = `Basic ${btoa('API-key')}`;
```

> Make sure to replace `API-key` with your API key.

> Response

```json
{
  "Authorization": "Basic VGhpcyBpcyBhbiBlbmNvZGVkIHN0cmluZw=="
}
```

You will receive a API key and an API secret. Each end-point requires either just an API key or both key and secret to authenticate.
We use HTTP Basic Authentication, which is in the format `apikey:apisecret` that is base64 encoded and prepended with the string 'Basic '.

For example if the end requires only an API Key:
Leave the api secret field empty.
Base64 encode 'abc123:', no password after the colon, and the final result will be 'YWJjMTIzOg=='.

This is passed in the authorization header like so `Authorization: Basic YWJjMTIzOg==`.

For API endpoints requiring API key and secret, do the same as above, except in step 1 the api secret must be filled.

## Content-Type
You must set a content-type header to 'application/json'.
`Content-Type: application/json`

# Events
All events are registered in a similar format. There are 4 main objects in each request.

Parameter | Required | Description
--------- | ------- | -----------
user | true | All data that we know about the current user at the time. (MANDATORY)
event | true | Details about the event (MANDATORY)
context | false | Details about the user’s device and location (OPTIONAL)

<aside class="success">
  Parameter breakdown
</aside>

#### User

User Identification (one of the two is mandatory, we will take `user_id` if you send both)

- `user_id` : the user_id of the user if he/she has logged in

- `anonymous_id`: an automatically generated visitor id if the user has not logged in.

- `profile`: any information you’ve collected about the user. For instance, if you run a fashion store and ask the user whether they want to see a men/women version of the store. Please add this information under the profile.

#### Event

- `type`: a mandatory field: it can be 'pageview', 'viewcart', 'search', 'wishlist', 'click', 'order' or 'login'

- `subtype`: required depending on the event type. For instance, pageview, wishlist and click require a subtype.

#### Context

- `ip`: the users IP. If you don’t specify one, we will store the IP sent from the request header.

- `user_agent`: If you don’t specify one, we will store the user_agent from the request header.
NOTE: This only applies if you are registering events from client side or frontend code running on a browser, typically in a single page application. If your store is rendered on the server for instance with PHP, you must specify these fields as the request IP and user_agent we receive will be from your server.

- `timestamp`: An ISO-8601 date string in UTC time for when the event happened (OPTIONAL)
If you don’t specify this, we will log the event at current UTC time. It is recommended to only specify this field if you are sending us any historical data.

## Home Page View

```php
<?
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
?>
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "Fluffums",
    "breed": "calico",
    "fluffiness": 6,
    "cuteness": 7
  },
  {
    "id": 2,
    "name": "Max",
    "breed": "unknown",
    "fluffiness": 5,
    "cuteness": 10
  }
]
```

This endpoint retrieves all kittens.

### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

## Get a Specific Kitten

```php
<?
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
?>
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Max",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">Inside HTML code blocks like this one, you can't use Markdown, so use <code>&lt;code&gt;</code> blocks to denote code.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

## Delete a Specific Kitten

```php
<?
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
?>2
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "deleted" : ":("
}
```

This endpoint deletes a specific kitten.

### HTTP Request

`DELETE http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to delete

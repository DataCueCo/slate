# Errors

The API returns 3 types of error codes:

Error Code | Meaning
---------- | -------
400 | Bad Request -- Your request is invalid. With a payload that has a descriptive error message. We're always trying to improve so let us know if you encounter any issues interpreting the error message.
401 | Unauthorized -- Specified the wrong API key or API secret. Incorrectly formatted authorization header. Specifying an API secret in an endpoint that only requires an API key
500 | Internal Server Error -- We had a problem with our server. Try again later.

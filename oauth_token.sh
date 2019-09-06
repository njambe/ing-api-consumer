#! /usr/bin/env sh

clientid=$(cat clientid)

payload="grant_type=client_credentials&scope=greetings%3Aview"
payloadDigest=$(echo -n "$payload" | openssl dgst -binary -sha256 | openssl base64)
digest=SHA-256=$payloadDigest
reqDate=$(LC_TIME=en_US.UTF-8 date -u "+%a, %d %b %Y %H:%M:%S GMT")
reqId=$(uuidgen)
httpMethod=post
reqPath="/oauth2/token"

signingString="(request-target): $httpMethod $reqPath
date: $reqDate
digest: $digest"

signature=$(printf "$signingString" | openssl dgst -sha256 -sign http_sign/server.key | openssl base64 -A)

curl -X POST "https://api.ing.com${reqPath}" \
	-H 'Accept: application/json' \
	-H 'Content-Type: application/x-www-form-urlencoded' \
	-H "Digest: ${digest}" \
	-H "Date: ${reqDate}" \
	-H "authorization: Signature keyId=\"${clientid}\",algorithm=\"rsa-sha256\",headers=\"(request-target) date digest\",signature=\"$signature\"" \
	-d "${payload}" \
	--cert tls_mutual/server_public.crt \
	--key tls_mutual/server.key | jq -r '.access_token'


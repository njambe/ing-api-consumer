#! /usr/bin/env sh

access_token="$1"

payload=""

payloadDigest=$(echo -n "$payload" | openssl dgst -binary -sha256 | openssl base64)
digest=SHA-256=$payloadDigest

clientid=$(cat clientid)

#Host and path
host=api.ing.com
reqPath="/greetings/single"

#actual request date
reqDate=$(LC_TIME=en_US.UTF-8 date -u "+%a, %d %b %Y %H:%M:%S GMT")

#signing the request
signingString="(request-target): get $reqPath
date: $reqDate
digest: $digest"

signature=$(printf "$signingString" | openssl dgst -sha256 -sign http_sign/server.key | openssl base64 -A)

curl -i "https://${host}${reqPath}" \
	-H "Authorization: Bearer ${access_token}" \
	-H "Digest: ${digest}" \
	-H "Date: ${reqDate}" \
	-H "Signature: keyId=\"${clientid}\",algorithm=\"rsa-sha256\",headers=\"(request-target) date digest\",signature=\"$signature\"" \
	--cert tls_mutual/server_public.crt \
	--key tls_mutual/server.key

import requests
import urllib
import json
import httplib

params = {
    "grant_type": "password",
    "client_id": "3MVG9Nk1FpUrSQHcPvr2.BsaUQTXWVywG82nqv_gJdrE_5v0qrnshPJcUfmQp.k9baFeRIlBagjANN4ou2QaE", # Consumer Key
    "client_secret": "67C3E837B0749B2B119F8FF0054C284BFC5A30AD9161B51996BDA103F4A4E2E4", # Consumer Secret
    "username": "alejandro.emailiphone@gmail.com", # The email you use to login
    "password": "HomeProject/2021" # Concat your password and your security token
}
r = requests.post("https://login.salesforce.com/services/oauth2/token", params=params)
# if you connect to a Sandbox, use test.salesforce.com instead
access_token = r.json().get("access_token")
instance_url = r.json().get("instance_url")

def sf_api_call(action, parameters = {}, method = 'get', data = {}):
    """
    Helper function to make calls to Salesforce REST API.
    Parameters: action (the URL), URL params, method (get, post or patch), data for POST/PATCH.
    """
    headers = {
        'Content-type': 'application/json',
        'Accept-Encoding': 'gzip',
        'Authorization': 'Bearer %s' % access_token
    }
    if method == 'get':
        r = requests.request(method, instance_url+action, headers=headers, params=parameters, timeout=30)
    elif method in ['post', 'patch']:
        r = requests.request(method, instance_url+action, headers=headers, json=data, params=parameters, timeout=10)
    else:
        # other methods not implemented in this example
        raise ValueError('Method should be get or post or patch.')
    print('Debug: API %s call: %s' % (method, r.url) )
    if r.status_code < 300:
        if method=='patch':
            return None
        else:
            return r.json()
    else:
        raise Exception('API error when calling %s : %s' % (r.url, r.content))



response = requests.get('https://api-beta.packetfabric.com/v2/locations').text
response_info = json.loads(response)
for p in response_info:
    call = sf_api_call('/services/data/v40.0/sobjects/SiteLocation__c/', method="post", data={
    'Address1__c': p['address1'],
    'Address2__c': p['address2'],
    'City__c': p['city'],
    'Country__c': p['country'],
    'POP__c': p['pop'],
    'Postal__c': p['postal'],
    'Site__c': p['site'],
    'SiteCode__c': p['site_code'],
    'State__c': p['state'],
})

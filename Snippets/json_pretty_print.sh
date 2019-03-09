#!/usr/bin/env sh


JSONDATA='{"object":{"users":[{"name":"JohnDoe","username":"jdoe","expires_utc":"","identity":true,"admin":true},{"name":"JillDoe","username":"jidoe","expires_utc":"","identity":true,"admin":false}],"general":{"id":1,"mac_address":"AA:BB:CC:DD:EE:FF","barcode_1":"1234567890","barcode_2":"0987654321","ip_address":"127.0.0.1","status":{"enrolled":false,"provisioned":true,"decommisoined":false},"name":"MacBook"},"software":{"applications":[],"available_software_updates":[],"available_updates":{},"fonts":[],"installed":["AdobeFlash.pkg","Safari.pkg","Firefox.pkg","GoogleChrome.pkg"],"long_list1":["precontain","skeletony","oostegite","Saban","chokidar","cloam","dysprosia","nonvillager","baggit","Bucorvinae","won","enation","waringin","ninth","inflected","pilomotor","gandergoose","quadriad","municipality","interval"],"empty_list1":[],"long_list2":["horsily","tabidness","arar","Fontainea","reactionarism","gayatri","loveful","counterclaimant","unsocialness","protective"],"empty_list2":[]}}}'

printf -- "$(echo "$JSONDATA" | json_pp )"

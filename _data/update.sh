#!/bin/bash
#
# Script to update list of publications by OTN members
# using Wikidata

curl 'https://query.wikidata.org/sparql?query=%23%20tool%3A%20scholia%0A%23defaultView%3ATable%0A%0APREFIX%20target%3A%20%3Chttp%3A%2F%2Fwww.wikidata.org%2Fentity%2FQ112326635%3E%0A%0ASELECT%0A%20%20%3Fpublication_date%0A%20%20%3Fwork%20%3FworkLabel%0A%20%20%3Fresearchers%20%3FresearchersUrl%0AWITH%20%7B%0A%20%20SELECT%20%0A%20%20%20%20(MIN(%3Fpublication_datetimes)%20AS%20%3Fpublication_datetime)%20%3Fwork%20%0A%20%20%20%20(GROUP_CONCAT(DISTINCT%20%3Fresearcher_label%3B%20separator%3D%27%2C%20%27)%20AS%20%3Fresearchers)%0A%20%20%20%20(CONCAT(%22..%2Fauthors%2F%22%2C%20GROUP_CONCAT(DISTINCT%20SUBSTR(STR(%3Fresearcher)%2C%2032)%3B%20separator%3D%22%2C%22))%20AS%20%3FresearchersUrl)%0A%20%20WHERE%20%7B%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%0A%20%20%20%20%3Fresearcher%20(%20wdt%3AP108%20%7C%20wdt%3AP463%20%7C%20wdt%3AP1416%20)%20%2F%20wdt%3AP361*%20target%3A%20.%0A%20%20%20%20%3Fwork%20wdt%3AP50%20%3Fresearcher%20.%0A%20%20%20%20%3Fresearcher%20rdfs%3Alabel%20%3Fresearcher_label%20.%20FILTER%20(LANG(%3Fresearcher_label)%20%3D%20%27en%27)%0A%20%20%20%20OPTIONAL%20%7B%0A%20%20%20%20%20%20%3Fwork%20wdt%3AP577%20%3Fpublication_datetimes%20.%0A%20%20%20%20%7D%0A%20%20%7D%0A%20%20GROUP%20BY%20%3Fwork%0A%20%20ORDER%20BY%20DESC(%3Fpublication_datetime)%0A%20%20LIMIT%202000000%20%20%0A%7D%20AS%20%25results%0AWHERE%20%7B%0A%20%20INCLUDE%20%25results%0A%20%20BIND(xsd%3Adate(%3Fpublication_datetime)%20AS%20%3Fpublication_date)%0A%20%20SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%2Cda%2Cde%2Ces%2Cfr%2Cjp%2Cnl%2Cnl%2Cru%2Czh%22.%20%7D%0A%7D%0AORDER%20BY%20DESC(%3Fpublication_date)%0A' -H "Accept: text/csv" > publications.csv


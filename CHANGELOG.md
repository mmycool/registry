15.10.2018
* Nokogiri update 1.8.5 [#1007](https://github.com/internetee/registry/pull/1007)
* Registrant API: added admin, tech and registrar contacts to domain info response [#991](https://github.com/internetee/registry/issues/991)
* Registrant API: added nameserver and registrar details to domain info response [#1000](https://github.com/internetee/registry/issues/1000)
* Registrant API: added registry lock date to domain info response [#996](https://github.com/internetee/registry/issues/996)

02.10.2018
* EPP: datetime in poll messages is not UTC as required by RFC5730 [#948](https://github.com/internetee/registry/issues/948)
* BUG: user_session_timeout is now always respected [#966](https://github.com/internetee/registry/issues/966)
* BUG: fixed method name in registrar portal's billing [#971](https://github.com/internetee/registry/pull/971)
* RubyZip gem update to 1.2.2 (https://nvd.nist.gov/vuln/detail/CVE-2018-1000544) [#987](https://github.com/internetee/registry/pull/987)
* Rubocop gem update to 0.5.8 [#963](https://github.com/internetee/registry/pull/963)
* Money gem update to 6.12.0 [#968](https://github.com/internetee/registry/pull/968)
* Admin: Removing PKI certs revoke the cert first [#887](https://github.com/internetee/registry/issues/887)
* Admin: removed duplicate billing email field from registrar profile [#967](https://github.com/internetee/registry/issues/967)
* Removed duplicate require function [#979](https://github.com/internetee/registry/issues/979)
* Improved EPP poll tests [#943](https://github.com/internetee/registry/issues/943)
* Refactored EPP poll messages [#703](https://github.com/internetee/registry/issues/703)
* Registrant portal small improvements [#932](https://github.com/internetee/registry/issues/932)
* Fixed invoice mailer whitelist for staging env enablig invoice forwarding to an email [#989](https://github.com/internetee/registry/issues/989)
* Removed unused domain delete views [#951](https://github.com/internetee/registry/issues/951)
* Removed unused generator [#990](https://github.com/internetee/registry/issues/990)

12.09.2018
* Bug: user with billing access only can now login to the portal for Regsitrars [#973](https://github.com/internetee/registry/issues/973)

06.09.2018
* Bug: registrant confirmation does not require authentication any more [#969](https://github.com/internetee/registry/issues/969)
* Whois JSON tests order independent [#965](https://github.com/internetee/registry/issues/965) 

04.09.2018
* New registrant portal API [#902](https://github.com/internetee/registry/issues/902)
* Registry lock in Registrant API [#927](https://github.com/internetee/registry/issues/927)
* Password encryption for EPP [#914](https://github.com/internetee/registry/issues/914)
* Registrar: 0 amount invoices invalidated [#651](https://github.com/internetee/registry/issues/651)
* Ruby upgrade to 2.4 [#938](https://github.com/internetee/registry/issues/938)
* Admin: removig deleteCandidate status removes Que job as well [#790](https://github.com/internetee/registry/issues/790)
* Admin: Cancel force delete no possible with deleteCandidate status set [#791](https://github.com/internetee/registry/issues/791)
* Contact tests added [#930](https://github.com/internetee/registry/issues/930)
* Change test structure [#924](https://github.com/internetee/registry/issues/924)
* Grape gem update to 1.1.0 (CVE-2018-3769) [#934](https://github.com/internetee/registry/pull/934)
* Remove changelog from codeclimate analysis [#961](https://github.com/internetee/registry/issues/961)
* Remove dead code [#925](https://github.com/internetee/registry/issues/925)
* Quote value in fixture [#937](https://github.com/internetee/registry/issues/937)
* Generate <body> CSS class for every action [#939](https://github.com/internetee/registry/issues/939)
* Add TaskTestCase [#941](https://github.com/internetee/registry/issues/941)
* Set NOT NULL constraint for contact.email field [#936](https://github.com/internetee/registry/issues/936)
* Remove duplicate fixture [#946](https://github.com/internetee/registry/issues/946)

26.07.2018
* Grape (1.0.3), mustermann (1.0.2), multi_json (1.13.1) gem updates [#912](https://github.com/internetee/registry/issues/912)
* Capybara (3.3.1), mini_mime (0.1.3), nokogiri (1.8), rack (1.6.0), xpath (3.1) gem updates [#980](https://github.com/internetee/registry/issues/908)
* Webmock (3.4.2), addressable (2.5.2), hashdiff (0.3.7), public_suffix (3.0.2) gem updates [#907](https://github.com/internetee/registry/issues/907)
* fixed typo in assertions filename [#920](https://github.com/internetee/registry/issues/920)
* regenerate structure.sql [#915](https://github.com/internetee/registry/issues/915)

12.07.2018
* Implemented JavaScript testing framework to catch web UI problems [#900](https://github.com/internetee/registry/issues/900)

10.07.2018
* Nameserver bulk change returns list of affected doamins [#835](https://github.com/internetee/registry/issues/835)

26.06.2018
* Whois data is updated now on pendingUpdate status removal [#757](https://github.com/internetee/registry/issues/757)
* Portal for registrars displays control code for MID authentication [#893](https://github.com/internetee/registry/issues/893)
* Changed date format in Directo invoice XML [#890](https://github.com/internetee/registry/pull/890)
* Registrant portal UI improvements [#888](https://github.com/internetee/registry/issues/888)
* Removed unused mailer code [#882](https://github.com/internetee/registry/pull/882)
* Sprocets gem update to 3.7.2 [#892](https://github.com/internetee/registry/issues/892)
* Replased Warden test helpers with Devise [#889](https://github.com/internetee/registry/issues/889)
* Removed dev rake task [#872](https://github.com/internetee/registry/pull/872)
* Spring gem removed [#856](https://github.com/internetee/registry/issues/856)
* Dcker conf changes [#881](https://github.com/internetee/registry/pull/881)
* Fixed Estonia in the country drop-down [#877](https://github.com/internetee/registry/issues/877)
* Codeclimate conf improvements [#854](https://github.com/internetee/registry/pull/854)
* Removed codeclimate badge from README [#876](https://github.com/internetee/registry/issues/876)
* added UUID for contact objects [#873](https://github.com/internetee/registry/pull/873)
* backported Rails 5 API [#868](https://github.com/internetee/registry/issues/868)

20.06.2018
* Bulk change function for technical contact replacement [#662](https://github.com/internetee/registry/issues/662)
* Removed vatcode and totalvat elements from directo request in attempt to fix invoice sending issue [#844](https://github.com/internetee/registry/issues/844)
* Regsitrar: added credit card payment option - disabled at the moment due to contractual reaons [#419](https://github.com/internetee/registry/issues/419)
* Registrant: enabled WHOIS requests over RestWHOIS API [#852](https://github.com/internetee/registry/issues/852)
* Fixed rspec configuration that caused test failures [#858](https://github.com/internetee/registry/issues/858)
* Admin: refactored date selection in pricelist [#869](https://github.com/internetee/registry/issues/869)
* Added uglifier gem for es6 compression [#864](https://github.com/internetee/registry/issues/864)
* Removed lib folder from autoload path [#859](https://github.com/internetee/registry/issues/859)
* test environment config improvements [#860](https://github.com/internetee/registry/issues/860)
* translation fixes [#865](https://github.com/internetee/registry/issues/865)
* removed obsolete .agignore [#866](https://github.com/internetee/registry/issues/866)
* removed rubocop gem [#857](https://github.com/internetee/registry/issues/857)
* new invoice payment test fix [#863](https://github.com/internetee/registry/issues/863)
* get puma gem config from Rails 5 [#867](https://github.com/internetee/registry/issues/867)
* Rails5 API controller temporary backport [#868](https://github.com/internetee/registry/issues/868)

25.05.2018
* GDPR: updated whois templates with configurable disclaimer [#795](https://github.com/internetee/registry/issues/795)
* GDPR: email forwarding solution to contact private domain registrants without revealing their email addresses [#824](https://github.com/internetee/registry/issues/824)
* EPP: added support for additional digitally signed doc formats like asice, sce, asics, scs, edoc, adoc [#840](https://github.com/internetee/registry/issues/840)
* Registrar: removed handling of newlines from contact form street field [#836](https://github.com/internetee/registry/issues/836)
* Ruby upgrade to version 2.3.7 [#546](https://github.com/internetee/registry/issues/546)
* Devise upgrade to version 4.4.3 [#847](https://github.com/internetee/registry/pull/847)
* Added extra logging to debug Directo integration [#848](https://github.com/internetee/registry/pull/848)

30.04.2018
* Upgrade Ruby on Rails to version 4.2.10 [#826](https://github.com/internetee/registry/issues/826)
* BUG: Admin - fixed internal error in domain_versions and contact_versions views caused by removed db column [#830](https://github.com/internetee/registry/issues/830)

23.04.2018
* WHOIS: domains with deleteCandidate status do not return registration details as domains waiting to be deleted [#789](https://github.com/internetee/registry/issues/789)
* Security: Nokigiri gem update to version 1.8.2 [#823](https://github.com/internetee/registry/pull/823)
* Bug: fixed missing translation error in admin mail templates page [#818](https://github.com/internetee/registry/pull/818)
* Admin: VAT percentage info to registrar profile for setting tax rate for foreign non vat liable registrars [#623](https://github.com/internetee/registry/issues/623)
* Admin: deleteCandidate status is now stressed in domain details view [#792](https://github.com/internetee/registry/issues/792)
* Removed invoice_type from invoice db data as unused [#772](https://github.com/internetee/registry/issues/772)
* Removed valid_from from domain db data as duplicated and unused [#787](https://github.com/internetee/registry/issues/787)
* Set Not null constraint to valid_ti domain db data [#800](https://github.com/internetee/registry/issues/800)
* Removed unused methods [#797](https://github.com/internetee/registry/issues/797)
* Removed unused cron tasks [#782](https://github.com/internetee/registry/issues/782)
* Removed some monkey-patching for flash message logging [#231](https://github.com/internetee/registry/issues/231)
* Added Docker container support for dev and test environments [#821](https://github.com/internetee/registry/issues/821)
* Fix for Travis CI random test failures [#809](https://github.com/internetee/registry/pull/809)

03.04.2018
* BUG: Fixed bug with sometimes failing bank-link payments [#642](https://github.com/internetee/registry/issues/642)
* EPP: Domain and associated objects are now validated on domain renew [#678](https://github.com/internetee/registry/issues/678)
* Admin: drop uniqueness requirement from registrar's registry number field [#776](https://github.com/internetee/registry/issues/776)
* Security: Loofah gem update to 2.2.2 [#783](https://github.com/internetee/registry/pull/783)
* Disabled spellcheck for browsers to cleanup UI [#759](https://github.com/internetee/registry/issues/759)
* Admin: refactored registrar management [#770](https://github.com/internetee/registry/pull/770)
* Fix structure.sql [#796](https://github.com/internetee/registry/pull/796)

19.03.2018
* EPP transfer and REPP bulk transfer reuses contact objects [#746](https://github.com/internetee/registry/issues/746)
* Gems: Rack (1.6.9) and Rack-protection (1.5.5) update [#768](https://github.com/internetee/registry/issues/768)
* Removal of unused database tables [#756](https://github.com/internetee/registry/issues/756)
* Removal of unused date format [#764](https://github.com/internetee/registry/pull/764)
* Removal of billing postal address [#747](https://github.com/internetee/registry/issues/747)

06.03.2018
* BUG: Transfer poll message now returns affected domain name [#694](https://github.com/internetee/registry/issues/694)
* BUG: Successful REPP bulk transfer returns info about transfered domains [#693](https://github.com/internetee/registry/issues/693)
* BUG: Postal address data is not validated when address processing is disabled [#731](https://github.com/internetee/registry/issues/731)
* EPP: invalid country code message (code 2005) specifies invalid value [#733](https://github.com/internetee/registry/issues/733)
* REPP: new bulk nameserver change feature, also available on the portal for registars [#661](https://github.com/internetee/registry/issues/661)
* Admin: disable auto-email feature on setting force delete [#727](https://github.com/internetee/registry/issues/727)
* jQuery validation gem removed [#744](https://github.com/internetee/registry/issues/744)

22.02.2018
* BUG: Registrar: contact list export is not limited to 75 records any more [#721](https://github.com/internetee/registry/issues/721)
* BUG: EPP: domain and associated objects are not validated on domain delete [#707](https://github.com/internetee/registry/issues/707)
* EPP: improved session management (db constraints, model and db structure refactor, auto-tests) [#700](https://github.com/internetee/registry/issues/700)

11.02.2018
* BUG: Disable all object validations on domain transfer [#701](https://github.com/internetee/registry/issues/701)

06.02.2018
* BUG: EPP sessions get again unique session id preventing session mixups [#699](https://github.com/internetee/registry/pull/699)

06.02.2018
* BUG: Poral for registrants returns again domains that is associated with the user only through the role of registrant [#663](https://github.com/internetee/registry/issues/663)
* Registrar: bulk transfer and improved csv download for use as bulk transfer input [#660](https://github.com/internetee/registry/issues/660)
* Improved integration with CodeClimate, Simplecov gem update to 15.1 [#684](https://github.com/internetee/registry/pull/684)
* Improved applycation.yml sample [#664](https://github.com/internetee/registry/pull/664)

11.12.2017
* BUG: Whitelisted registrar is now automatically chosen on eID/mID login [#609](https://github.com/internetee/registry/issues/609)
* BUG: added directo_handle to registrar profile [#343](https://github.com/internetee/registry/issues/343)
* Refactored ident validations on contact updates [#569](https://github.com/internetee/registry/issues/569)
* Admin: Added registrar communication language setting [#640](https://github.com/internetee/registry/issues/640)
* Update rubocop to 0.49 [#605](https://github.com/internetee/registry/pull/605)
* Code cleanup:
  * remove test.rake [#376](https://github.com/internetee/registry/pull/376)
  * remove docker remnants [#614](https://github.com/internetee/registry/pull/614)
  * remove phantomjs, phantomjs-binaries and launchy gems [629](https://github.com/internetee/registry/pull/629)
  * remove eis_custom_active_model.rb, eis_custom_active_record.rb, eis_custom_flash.rb [#231](https://github.com/internetee/registry/issues/231)
  * remove autolable.rb [#407](https://github.com/internetee/registry/issues/407)
* migration from FactoryGirl to FactoryBot [#626](https://github.com/internetee/registry/pull/626)
  * remove FactoryGirl from dev.rake [#630](https://github.com/internetee/registry/pull/630)
* add rake todo list [#586](https://github.com/internetee/registry/pull/586)

13.10.2017
* BUG: week starts with Monday now in the date picker of the portal for registrars and admin interface [#590](https://github.com/internetee/registry/issues/590)
* BUG: Fixed error on zone file generation in the admin interface [#611](https://github.com/internetee/registry/issues/611)
* Improved expire email readability [#598](https://github.com/internetee/registry/pull/598)
* Improved registrar portal access denied page [#599](https://github.com/internetee/registry/pull/599)
* Admin interface uses base controller [#585](https://github.com/internetee/registry/pull/585)
* Admin interface settings refactored [#583](https://github.com/internetee/registry/pull/583)
* Nokogiri gem update 1.8.1 [#595](https://github.com/internetee/registry/pull/595)
* Mail gem update 2.6.6 [#596](https://github.com/internetee/registry/pull/596)
* Improved rubocop inspections [#579](https://github.com/internetee/registry/issues/579)
* Removed "restful_whois_url" config key [#494](https://github.com/internetee/registry/pull/494)
* Removed robot bin [#505](https://github.com/internetee/registry/pull/505)
* Configurabel session timeouts for dev and test environments [#588](https://github.com/internetee/registry/pull/588)
* Generators disabled [#606](https://github.com/internetee/registry/pull/606)

15.06.2017
* BUG: fixed incorrect error message on domain upate in case serverDeleteProhibited was set [#512](https://github.com/internetee/registry/issues/512)
* BUG: removed references to postal addresses from last email templates in case address processing is disabled [#480](https://github.com/internetee/registry/issues/480)
* Removed options to delete pricelist items and zones [#522](https://github.com/internetee/registry/issues/522)
* Improved registry database setup process [#503](https://github.com/internetee/registry/issues/503)
* Added dummy data generation rake task [#515](https://github.com/internetee/registry/issues/515)

02.05.2017
* Set default period value of domain create and renew operations to 1 year in the Registrar portal [#495](https://github.com/internetee/registry/issues/495)

01.05.2017
* Support for short and long regsitration periods - from 3m to 10y [#475](https://github.com/internetee/registry/issues/475)
* Improved race condition handling on domain renew [#430](https://github.com/internetee/registry/issues/430)

05.04.2017
* Fixed validation error on valid legaldocs in the portal for registrars [#432](https://github.com/internetee/registry/issues/432)
* Updated Ruby, nokogiri and variouse other dependent gems to fix security issues
* Template selection for setting ForceDelete status in admin interface and new template for deceased registrant [#268](https://github.com/internetee/registry/issues/268)

14.03.2017
* Improved phone number validation [#386](https://github.com/internetee/registry/issues/386)
* Dropped ddoc support from legaldocs in the portal for regsitrars [#270](https://github.com/internetee/registry/issues/270)
* Bug: Domain in exp pending list whithout the state present [#328](https://github.com/internetee/registry/issues/328)
* Base64 of legaldocs filtered out from syslogs [#314](https://github.com/internetee/registry/issues/314)

02.03.2017
* Domain list download (csv) functionality in the portal for registrars (#248)
* Readme updates (#273)
* Epp-examples.md update with contact create examples with postal address processing disabled (#326)
* Autotest improvements and updates

28.02.2017
* Add missing registrar's website field in UI

24.01.2017
* Disallow EPP domain:update/transfer/delete if a domain has "deleteCandidate" status

22.12.2016
* Return business registry code and country for 'org' type registrants in WHOIS and Rest-WHOIS

16.12.2016
* Allow contact address processing to be configurable via admin
* EPP XML schema namespace "urn:ietf:params:xml:ns:epp-1.0" replaced with "https://epp.tld.ee/schema/epp-ee-1.0.xsd"
* EPP XML schema contact-eis-1.0 replaced with contact-ee-1.1

18.11.2016 
* Domain expiration emails are now sent out to admin contacts as well. Sending bug is fixed.
* Include detailed registrar's contact info in emails

07.11.2016 
* Use app time zone when calculating valid_to, outzone_at and delete_at domain attributes
* Treat domains as expired when expire_time is set to current time
* Improve domain's outzone and delete logic

25.10.2016 
* Outdated specs removed, failing specs fixed, rspec config improved

20.10.2016
* Travis CI integration added, New Relic removed

19.10.2016
* BUG fix: Record current time for outzone on domain:delete EPP request
* ForceDelete automatic notice: fixed et and ee wording to reflect the date the domain is actually deleted.

9.09.2016
* Registry:
  * domains expire now at the beginning of the date followed by the date of regsitration. Expiration and redemption grace periods now follow domainregulations more correctly and delete date returned in whois matches the date the domain is actually deleted (129684535)

31.08.2016
* Admin interface:
  * contact id supports wildcard search with '%' (129124951)
* Registry:
  * BUG: whodunnit filled with incorrect user reference in case of pending request confirmations and rejections (115693873)
  * domain_cron.rb now searches for domains to be archived using the end of the day parameter allowing it to be run at any time during the day (113430903)
* EPP:
  * Invalid use of GET is now logged and replied with proper error message instead of internal error (128054415)
* Portal for registrars
  * BUG fix: invoices now dipslay description entered by registrar on invoice request

9.08.2016
* Admin interface:
  * actions are now clickable in domain and contact history and return the initial epp request sent to registry (117806281)
  * access to archived domain and contact objects under settings (108869472)
  * BUG: noaccess fixed for contacts with incomplete ident data (120093749)
* Registry:
  * BUG: adding contact do a domain generated unnecessary log records (116761157)
  * linked state for a contact is now dynamic (116761157)
* Portal for registrars:
  * improved dnssec data presentation in ds data interface mode (118007975)
  * BUG: now all the ident data is returned for contacts with incomplete set (120093749)
* EPP
  * BUG: invalid error 2304 "Object status prohibits operation" (118822101)
  * BUG: invalid error 2302 "Nameserver already exists on this domain" (118822101)

14.07.2016
* Registry:
  * whois records generation fix in contact.rb model (#117612931)
  * english translation fix for pending_update_notification_for_new_registrant automated registrant message

16.06.2016
* EPP
  * BUG: XML syntax error for poll and logout if optional clTRID is missing (#121580929)
  * support for glue records with ipv6 addresses only (#120095555)

15.06.2016
* Portal for registrants
  * Notice on login screen on limited access to Estonian electronic IDs (#120182999)
* Admin interface:
  * epp log view has now reference to the object name for better usability (#118912395)
  * BUG: dnssec data missing from domain history view (#115762063)
  * BUG: internal error in doamin history view in case some contact has been deleted (#118300251)
* Registry:
  * all values sent over epp are now trimmed of beginning and trailing spaces (#117690107)
  * typo and form fixes for automated e-mail messages sent to domain contacts
* EPP:
  * BUG: error 2005 on adding IDN nameservers (#114677695)
  * BUG: nameserver lable maximum 63 char length validation handled inproperly (#114677695) - support currently limited to Estonian IDN characters.
  * BUG: validation passes out of range ident_type values - now limited to org, priv and birthday (#111601356)
  * BUG: internal error on hello (#120828283)
  * BUG: internal error broken incoming frame (#121580929)
* Deploy:
  * BUG: incorrect version in commit message on deploy - config/deploy-example.rb (#120259603)

20.05.2016
* Portal for registrars
  * domain details view new displays contact name in addition to ID (#117226457)
  * added an option to set veryfied = "yes" parameter to GUI for registrant change and domain delete opertions (#116209751)
* Admin interface
  * BUG: fixed number of sorting issues on different views (#117350717)
  * BUG: internal error on filtered list sorting (#115043065)
  * BUG: account activities csv export messes up registrars (#117702653)
  * usability fixes to history view (#115762063)
* Registry
  * epp-xml gem reference updated to v 1.0.5 (#116209751)
  * epp-xml gem is now taken from local repo https://github.com/internetee/epp-xml/blob/master, the version in RubyGems is not updated any more (#116209751)
  * BUG: domains set to force delete were deleted a day ahead of time (#117131083)
  * BUG: QUE - undefined method `code' for nil:NilClass - if contact is removed before Que gets to it (#117612061)
  * BUG: Que - uninitialized constant RegenerateWhoisRecordJob (#117986917)
* EPP
  * BUG: poll message on domain delete does not validate against .ee xml schemas (#118827261)
  * BUG: internal error on domain delete (#118159567)
* RestWHOIS
  * BUG: statuses not in array for not registered reserved and blocked domains (#118911315)

...

21.09.2015
* eis-1.0.xsd schema file updated without a new version, please publish a new updated schema file to public.

17.09.2015
* deploy-example.rb has been updated with `@cron_group`.

11.08.2015

* Possible to add whitelist_emails_for_staging list at application.yml

21.07.2015

* Possible to define custom trusted proxies at application.yml

20.07.2015

* New syntax for setting webclient IP-s (see config/application-example.yml)
* Example mina/deploy.rb renamed to mina/deploy-example.rb in order to not overwrite local deploy scripts

14.07.2015

* Updated que init script doc example, now status and stop works faster
* Updated registry server cronjob with mina cron:setup

07.07.2015

* Before applyling 20150707104937_refactor_reserved_domains.rb migration, enable hstore extension in db

01.07.2015

* Added que init script example at doc/que directory, please setup que accornding to doc/que/README.md

26.06.2015

* Added new relic license key ta application-example.yml, please update application.yml

22.06.2015

* Update zonefile

16.06.2015

* Application time_zone should be defined at application.yml, updated application-exaple.yml 

15.06.2015

* Apache config update: now only TLSv1.2 allowed with whitelisted chipers, please review all SSL config parameters

08.06.2015

* Add sk service name to application.yml
* Renew zonefile procedure

02.06.2015

* Added possibility to overwrite legal document types at application.yml level.

01.06.2015

* Added separate data update, all data migration locate at db/data, more info 'rake -T data'

29.05.2015

* Removed old 'iptables_counter_update_command' and added 'iptables_counter_enabled'

26.05.2015

* Added separate data update, all data migration locate at db/data, more info 'rake -T data'

29.05.2015

* Removed old 'iptables_counter_update_command' and added 'iptables_counter_enabled'
* Updated deploy script, now staging comes from staging branch

25.05.2015

* Added iptables counter command to application-example.yml
* Add update application.yml with correct `sk_digi_doc_service_endpoint`

22.05.2015

* Add `RequestHeader set SSL_CLIENT_CERT "%{SSL_CLIENT_CERT}s` to apache config (see README for details)

20.05.2015

* Added documentation how to configure linux firewall about rate limits, scirpts and more info at doc/debian_build_doc.md

19.05.2015

* Added possibility to define NewRelic app_name at application.yml file with 'new_relic_app_name' attribute. 

18.05.2015

* Added Registrant database example file: config/database-example-registrant.yml

16.05.2015

* Security config update. Please replace all Location and RedirectMatch 
  in Admin, Registrar and Registrant Apache2 config. New one are in readme.

15.05.2015

* Refer to doc/certificates.md for ID card login, note that CRL files in Apache config are not paths to CRL directory. (SSLCARevocationFile -> SSLCARevocationPath)

15.05.2015

* Added instractions for apache2 reload without password for Registrant/Registrar, 
  more info at doc/certificates.md

14.05.2015

* Changed and added some new smtp enviroment variables. More info at application-example.yml

13.05.2015

* Added Registrant portal and apache config example
* Added mina deploy script for registrant
* Added new environment for EPP server: 'registrant_url'

12.05.2015

* Ruby version updated to 2.2.2

11.05.2015

* Registrar: only dev can skip pki login certificate, 
  please be sure all application.yml and apache conf is correctly setup for pki
* Updated Registrar Apache example: added user name directive example config

24.04.2015

* Update zonefile procedure

23.04.2015

* Add `bank_statement_import_dir: 'import/legal_documents'` to application.yml, run `mina setup`

22.04.2015

* Configure smtp (see application-example.yml)

22.04.2015

* Whois database schema updated. Please reset whois database and run `rake whois:schema:load`

21.04.2015

* Install packages for wkhtmltopdf (see readme)
* Add `bank_statement_import_dir: 'import/bank_statements'` to application.yml, run `mina setup`

15.04.2015

* Added whois tasks, more info with rake -T whois

02.04.2015

* Depricated DelayedJob, kill all running delayed jobs if needed

27.03.2015
 
* Integrated DEPP engine to Registrar. Please note new DEPP configuration in application-example.yml
* Patched mod_epp for larger frames, reinstall mod_epp with patches found in README and restart Apache.

25.03.2015

* Added new cronjob for destroying orphaned contacts. Update cron by running `mina cron:setup` in registry project

24.03.2015

* New Registrar virtualhost added. Please refer to readme for the configuration.
* Note the improved configuration for the registry virtualhost:

```
# Rewrite /login to /admin/login
RewriteEngine on
RewriteCond %{REQUEST_URI} ^/login [NC]
RewriteRule ^/(.*) /admin/$1 [PT,L,QSA]

<Location ~ "/.+/" >
  Deny from all
</Location>

<Location ~ "/(admin|assets)\/.+">
  Allow from all
</Location>
```

19.03.2015

* New REPP virtualhost added. Please refer to readme for the configuration.
* Choose new domain for REPP interface and reconfigure repp_url parameter in webclient's application.yml

16.03.2015

* ruby upgraded to version 2.2.1, added RBENV upgrade howto to debian doc at: doc/debian_build_doc.md

27.02.2015

* Simplified config/application-example.yml, 
  now system will check if all required settings are present in application.yml 

19.02.2015

* Cetrificate only enabled, please setup certificates following doc/certificate.md document.

20.01.2015

* Added dedicated mina cron:setup and mina cron:clear for manual cron management.
  Automatic management during deploy removed.
* Added mina config for epp: "mina eppst deploy" and "mina epppr deploy" 

19.01.2015

* Added application-exapmle.yml and removed application.yml from repo, please 
  add config/application.yml back when deploying:
  cp current/config/application-example.yml shared/config/application.yml # and edit it
* Removed config/initilizers/devise_secret.rb, use application.yml

16.01.2015

* Added new rake tasks: rake db:all:setup to setup all databases
  Find out more tasks for all databases with rake -T db:all

* Staging env added, please change apache conf in staging servers to "RailsEnv staging"
  Then you need to add or update staging section in
  --> config/database.yml
  --> config/secrets.yml
  --> config/application.yml

15.01.2015

* Registry api log and whois database added, please update your database.yml,
  you can view updated config at config/database-example.yml
* Upgraded to Rails 4.2 and ruby 2.2.0, be sure you have ruby 2.2.0 in your rbenv 
  NB! Update you passenger deb install, it should have recent fix for ruby 2.2.0

14.01.2015

* Update your Apache EPP conf file, add "EPPRawFrame raw_frame", inspect example file at Readme
  Otherwise new master EPP will not work.

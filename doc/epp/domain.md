## Domain related functions

### Domain create

| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [create](#create)            | true     |      |                  |
| [extension](#top-domain-create-extension)         | true     |      |                  |
| clTRID         | false     |      | Client transaction id |

##### create
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:create](#domaincreate)     | true     | xmlns:domain (urn:ietf:params:xml:ns:domain-1.0) |  |


##### domain:create
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:name       | true     |  | Domain name. Can contain unicode characters. |
| domain:period     | false    | unit (y, m, d) | Registration period for domain. Must add up to 1 / 2 / 3 years. |
| [domain:ns](#domainns) | true     | | Nameserver listing (2-11) |
| domain:registrant | true     | | Contact reference to the registrant |
| domain:contact    | true if registrant is a juridical person     | type (admin) | Contact reference |
| domain:contact    | false     | type (tech, admin) | Contact reference (0-n) |

##### domain:ns
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:hostAttr](#domainhostattr)   | true     |  |  |

##### domain:hostAttr
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:hostName   | true     |  | Hostname of the nameserver |
| domain:hostAddr   | true if nameserver is under domain zone     | ip (v4, v6) | (0-n) |

##### <a name="top-domain-create-extension"></a>extension
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [secDNS:create](#secdnscreate)     | false     |  | DNSSEC details |
| [eis:extdata](#eisextdata)     | true     | xmlns:eis (urn:ee:eis:xml:epp:eis-1.0) | Legal document |

##### secDNS:create
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [secDNS:keyData](#secdnskeydata)       | true     | xmlns:secDNS (urn:ietf:params:xml:ns:secDNS-1.1) | DNSSEC key data |

##### secDNS:keyData
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| secDNS:flags     | true    |  | Allowed values: 0, 256, 257 |
| secDNS:protocol  | true     | | Allowed values: 3 |
| secDNS:alg | true     | | Allowed values: 3, 5, 6, 7, 8, 252, 253, 254, 255 |
| secDNS:pubKey    | true     |  | Public key |

##### eis:extdata
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| eis:legalDocument     | true    | type (pdf) | Base64 encoded document |

[EXAMPLE REQUEST AND RESPONSE](/doc/epp-doc.md#epp-domain-with-valid-user-with-citizen-as-an-owner-creates-a-domain)


### Domain update

| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [update](#update)            | true     |      |                  |
| [extension](#top-domain-update-extension)         | true if registrant is changing |      |                  |
| clTRID         | false     |      | Client transaction id |

##### update
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:update](#domainupdate) | true | xmlns:domain (urn:ietf:params:xml:ns:domain-1.0) |  |

##### domain:update
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:name       | true     |  | Domain name. Can contain unicode characters. |
| [domain:chg](#domainchg) | false |  | Attributes to change |
| [domain:add](#domainadd) | false |  | Objects to add |
| [domain:rem](#domainrem) | false |  | Objects to remove |

##### domain:chg
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:registrant | false     | | Contact reference to the registrant |

##### domain:add
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:ns](#domainns) | false     | | Nameservers TODO: Get rid of hostObj |
| domain:contact    | false     | type (tech, admin) | Contact reference (0-n) |
| domain:status    | false     | s (clientDeleteProhibited, clientHold, clientRenewProhibited, clientTransferProhibited, clientUpdateProhibited) | Status description (may be left empty) (0-n)|

##### domain:rem
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:ns](#domainns) | false     | | Nameservers TODO: Get rid of hostObj |
| domain:contact    | false     | type (tech, admin) | Contact reference (0-n) |
| domain:status    | false     | s (clientDeleteProhibited, clientHold, clientRenewProhibited, clientTransferProhibited, clientUpdateProhibited) | Status description (may be left empty) (0-n)|

##### <a name="top-domain-update-extension"></a>extension
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [secDNS:create](#secdnsupdate)     | false     |  | DNSSEC details TODO: MAYBE THIS SHOULD BE secDNS:update ? |
| [eis:extdata](#eisextdata)     | true if registrant is changing     | xmlns:eis (urn:ee:eis:xml:epp:eis-1.0) | Legal document |

##### <a name="secdnsupdate"></a>secDNS:create TODO: secDNS:update??
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [secDNS:add](#secdnsadd)     | false     |  | Objects to add |
| [secDNS:rem](#secdnsrem)     | false     |  | Objects to remove |

##### secDNS:add
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [secDNS:keyData](#secdnskeydata)       | true     | xmlns:secDNS (urn:ietf:params:xml:ns:secDNS-1.1) | DNSSEC key data (0-n)|

##### secDNS:rem
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [secDNS:keyData](#secdnskeydata)       | true     | xmlns:secDNS (urn:ietf:params:xml:ns:secDNS-1.1) | DNSSEC key data (0-n)|

[EXAMPLE REQUEST AND RESPONSE](/doc/epp-doc.md#epp-domain-with-valid-user-with-valid-domain-updates-domain-and-adds-objects)


### Domain delete

| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [delete](#delete)            | true     |      |                  |
| [extension](#top-domain-delete-extension)         | true |      |                  |
| clTRID         | false     |      | Client transaction id |

##### delete
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:delete](#domaindelete) | true | xmlns:domain (urn:ietf:params:xml:ns:domain-1.0) |  |

##### domain:delete
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:name       | true     |  | Domain name. Can contain unicode characters. |

##### <a name="top-domain-delete-extension"></a>extension
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [eis:extdata](#eisextdata)     | true     | xmlns:eis (urn:ee:eis:xml:epp:eis-1.0) | Legal document |

[EXAMPLE REQUEST AND RESPONSE](/doc/epp-doc.md#epp-domain-with-valid-user-with-valid-domain-deletes-domain)


### Domain info

| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [info](#info)            | true     |      |                  |
| [extension](#ext-legal-not-required)         | false |      |                  |
| clTRID         | false     |      | Client transaction id |


##### info
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:info](#domaininfo) | true | xmlns:domain (urn:ietf:params:xml:ns:domain-1.0) |  |


##### domain:info
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:name       | true     | hosts (all, TODO) | Domain name. Can contain unicode characters. |
| [domain:authInfo](#domainauthinfo)       | false     |  | Domain password |

##### domain:authinfo
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:pw       | true     | roid (String) TODO: find out why we need roid | Domain password |

##### <a name="ext-legal-not-required"></a>extension
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [eis:extdata](#eisextdata)     | false     | xmlns:eis (urn:ee:eis:xml:epp:eis-1.0) | Legal document |

[EXAMPLE REQUEST AND RESPONSE](/doc/epp-doc.md#epp-domain-with-valid-user-with-valid-domain-returns-domain-info)


### Domain renew

| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [renew](#renew)            | true     |      |                  |
| [extension](#ext-legal-not-required)         | false |      |                  |
| clTRID         | false     |      | Client transaction id |


##### renew
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:renew](#domainrenew) | true | xmlns:domain (urn:ietf:params:xml:ns:domain-1.0) |  |

##### domain:renew
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:name       | true     |  | Domain name. Can contain unicode characters. |
| domain:curExpDate | true     |  | Current expiry date (ISO8601 format) |
| domain:period | true     | unit (y, m, d) | Renew period, must add up to 1, 2 or 3 years. |

[EXAMPLE REQUEST AND RESPONSE](/doc/epp-doc.md#epp-domain-with-valid-user-with-valid-domain-renews-a-domain)


### Domain transfer
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [transfer](#transfer) | true     | op (approve, query, reject)     |     |
| [extension](#ext-legal-not-required)         | false |      |                  |
| clTRID         | false     |      | Client transaction id |

##### transfer
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:transfer](#domaintransfer) | true | xmlns:domain (urn:ietf:params:xml:ns:domain-1.0) |  |

##### domain:transfer
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:name       | true     |  | Domain name. Can contain unicode characters. |
| [domain:authInfo](#domainauthinfo)       | true     |  | Domain password |

[EXAMPLE REQUEST AND RESPONSE](/doc/epp-doc.md#epp-domain-with-valid-user-with-valid-domain-returns-domain-info)

### Domain check

| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [check](#check) | true     |      |     |
| [extension](#ext-legal-not-required)         | false |      |                  |
| clTRID         | false     |      | Client transaction id |

##### check
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| [domain:check](#domaincheck) | true | xmlns:domain (urn:ietf:params:xml:ns:domain-1.0) |  |

##### domain:transfer
| Field name        | Required | Attributes | Field description |
| ----------------- |----------| -----|----------------- |
| domain:name       | true     |  | Domain name. Can contain unicode characters. |

[EXAMPLE REQUEST AND RESPONSE](/doc/epp-doc.md#epp-domain-with-valid-user-checks-a-domain)
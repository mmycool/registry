# EPP integration specification

## Main communication specification through EPP

[Session related functions](session.md)  
[Contact related functions](contact.md)  
[Domain related functions](domain.md)  
[Keyrelay related functions](keyrelay.md)

## Supported protocols

- [RFC5730 - EPP](http://tools.ietf.org/html/rfc5730)  
- [RFC5731 - Domain Mapping](http://tools.ietf.org/html/rfc5731)  
- [RFC5733 - Contact Mapping](http://tools.ietf.org/html/rfc5733)  
- [RFC5734 - Transport over TCP](http://tools.ietf.org/html/rfc5734)  
- [RFC5910 - DNSSEC Mapping](http://tools.ietf.org/html/rfc5910)  
- [RFC3735 - Guidelines for Extending the EPP](http://tools.ietf.org/html/rfc3735)
- [Change Poll Draft v0.8](https://tools.ietf.org/html/draft-ietf-regext-change-poll-08)

## XML schemas

### Common
* [domain-1.0.xsd](/lib/schemas/domain-1.0.xsd)
* [contact-1.0.xsd](/lib/schemas/contact-1.0.xsd)
* [epp-1.0.xsd](/lib/schemas/epp-1.0.xsd)
* [eppcom-1.0.xsd](/lib/schemas/eppcom-1.0.xsd)
* [host-1.0.xsd](/lib/schemas/host-1.0.xsd)
* [keyrelay-1.0.xsd](/lib/schemas/keyrelay-1.0.xsd)
* [secDNS-1.1.xsd](/lib/schemas/secDNS-1.1.xsd)
* [changePoll-1.0.xsd](/lib/schemas/changePoll-1.0.xsd)

### .ee-specific
* [all-ee-1.0.xsd](/lib/schemas/all-ee-1.0.xsd)
* [all-ee-1.1.xsd](/lib/schemas/all-ee-1.1.xsd)
* [eis-1.0.xsd](/lib/schemas/eis-1.0.xsd)
* [epp-ee-1.0.xsd](/lib/schemas/epp-ee-1.0.xsd)
* [domain-eis-1.0.xsd](/lib/schemas/domain-eis-1.0.xsd)
* [contact-eis-1.0.xsd](/lib/schemas/contact-eis-1.0.xsd)
* [contact-ee-1.1.xsd](/lib/schemas/contact-ee-1.1.xsd)

More info about The Extensible Provisioning Protocol (EPP):
http://en.wikipedia.org/wiki/Extensible_Provisioning_Protocol

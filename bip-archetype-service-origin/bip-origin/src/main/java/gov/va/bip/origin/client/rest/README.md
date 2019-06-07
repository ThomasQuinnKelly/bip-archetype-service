# Feign Client Implementations

As described by [Baeldung](https://www.baeldung.com/intro-to-feign), Feign is a declarative HTTP client developed by Netflix. Feign aims at simplifying HTTP API clients. Simply put, the developer needs only to declare and annotate an interface while the actual implementation will be provisioned at runtime. See [Open Feign](https://github.com/OpenFeign/feign).

## Feign Usage

For external text-based HTTP services (e.g. RESTful services). If you need to call an external partner or public REST service, Feign makes it very easy.

For a simple example of a Feign client, see [bip-reference-person ../client/rest](https://github.com/department-of-veterans-affairs/bip-reference-person/tree/master/bip-reference-person/src/main/java/gov/va/bip/reference/person/client/rest).

## Partner Coding Pattern

In general, references to partner classes should not be referenced outside of this package. This may mean creating transform classes, and perhaps a partner adapter class. For examples of how to implement transformations, see these [example transform classes](https://github.com/department-of-veterans-affairs/bip-reference-person/tree/master/bip-reference-person/src/main/java/gov/va/bip/reference/person/transform/impl). To see how a simple adapter pattern was used between the provider and service layers, see the [Service Adapter class](https://github.com/department-of-veterans-affairs/bip-reference-person/blob/master/bip-reference-person/src/main/java/gov/va/bip/reference/person/api/provider/ServiceAdapter.java).

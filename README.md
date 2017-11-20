# Architecture RFC

## Structure

* *Network*
  * Abstract entity the describes the network in its entirety with all its nodes.
  * Servers are broken down into *organizations*.
  * Clients are broken down into *apps*.

* *Organization*
  * A distinct entity like a company that is operating nodes in the network.
  * Broken down into *clusters*.

* *Cluster*
  * A collection of services running in the same data center that make a single autonomous node in the network.
  * The cluster can run on a single machine or on multiple machines.
  * Organization running multiple clusters should run them on different cloud providers / geographic locations.
  * The level of trust internally within a cluster is higher but not absolute.
  * Broken down into *services*.

* *Service*
  * A backend program implementing a distinct function in the network adhering to a well defined interface.
  * Services are polyglots and can each be implemented in a different language or runtime.
  * There can be multiple implementations for the same service adhering to an identical interface.
  * Services can rely on common *libraries* to avoid duplicating code.

* *App*
  * A frontend program giving an end-user access to the *network*.
  * All clients are assumed to be light (mobile / web) and access the network through a backend *service*.
  * Apps can rely on common *libraries* to avoid duplicating code.

## Interfaces

  * Defined using [protocol-buffers](https://developers.google.com/protocol-buffers/docs/overview) version [proto3](https://developers.google.com/protocol-buffers/docs/proto3).
  * Services communicate internally inside a cluster using [gRPC](https://grpc.io/).
  * Clusters do not use gRPC to communicate among themselves externally.
  * The external communication protocol of same service peers in different clusters is under the responsibility of the service.

## Services

  * `PublicApi` - Exposes public web API (such as REST or JSON-RPC) to clients.
  * `TransactionPool` - Holds all pending transactions and a knowledge of past confirmed transactions.
  * `Broadcast` - Propagates information between all clusters in an efficient manner.
  * `Consensus` - Logic for consensus algorithm allowing separate clusters achieve a shared view of the world.
  * `StateStorage` - Holds all state (mutable and immutable) updated for the latest closed block.
  * `JournalStorage` - Holds incremental long-term storage used to generate the state (all past closed blocks).
  * `VirtualMachine` - Owns execution of smart contracts and holds the transient state for a pre-final execution.
  * `Processor` - The actual runtime environments for a smart contract in various languages (Python / JS / etc).
  * `TimeSync` - Synchronizes clocks, required to run on every machine that runs *TransactionPool* or *Consensus*.

## Libraries

  * `CryptoLib` - Contains implementations of low-level crypto routines in native (C) with non-native fallbacks.
  * `Client` - Client SDK for apps to connect end-users to the network through the *PublicApi* backend service.

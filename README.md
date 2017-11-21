# Architecture RFC

## Structure

* *Network*
  * Abstract entity the describes the network in its entirety with all its nodes.
  * Servers are broken down into *organizations*.
  * Clients are broken down into *apps*.

* *Organization*
  * A distinct entity like a company that is operating nodes in the network.
  * Broken down into *nodes*.

* *Node*
  * A collection of services running in the same data center that make a single autonomous node in the network.
  * The node can run on a single machine or on multiple machines.
  * Organization running multiple nodes should run them on different cloud providers / geographic locations.
  * The level of trust internally within a node is higher but not absolute.
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
  * Services communicate internally inside a node using [gRPC](https://grpc.io/).
  * Nodes do not use gRPC to communicate among themselves externally.
  * The external communication protocol of same service peers in different nodes is under the responsibility of the service.

## Services
<style>
  table.arch-table {
    width: 100%;
  }
  table.arch-table td{
    width: 16%;
    height: 50px;
    text-align: center;
    background: lightgrey;
    color: black;
  }
  table.arch-table td.not-implemented {
    color: grey;
  }
  table.arch-table th {
    width: 16%;
    borders: none;
    background:green;
    font-weight: 100;
  }

</style>
<table class="arch-table">
  <tr>
    <td>TimeSync</td>
    <td>Gossip</td>
    <td colspan="3"></td>
    <th>Layer IV<br>communications</th>
  </tr>
  <tr>
    <td colspan="2">
      Consensus
      <table class="arch-table">
      <tr>
        <td>TransactionPool</td>
      </tr>
      </table>
    </td>
    <td colspan="3">
      VirtualMachine
      <table class="arch-table">
      <tr>
        <td>Processor</td>
      </tr>
      </table>
    </td>
    <th>Layer III<br>blockchain</th>
  </tr>
  <tr>
    <td>JournalStorage</td>
    <td colspan="3">StateStorage</td>
    <td class="not-implemented">SidechainConnector</td>
    <th>Layer II<br>high-level storage</th>
  </tr>
  <tr>
    <td colspan="4">Raw Storage</td>
    <td class="not-implemented">Other blockchain</td>
    <th>Layer I<br>low-level storage</th>
  </tr>
</table>


  * `PublicApi` - Exposes public web API (such as REST or JSON-RPC) to clients.
  * `Broadcast` - Propagates information between all nodes in an efficient manner.
  * `Consensus` - Logic for consensus algorithm allowing separate nodes achieve a shared view of the world.
    * `TransactionPool` - Holds all pending transactions and a knowledge of past confirmed transactions.
  * `VirtualMachine` - Owns execution of smart contracts and holds the transient state for a pre-final execution.
    * `Processor` - The actual runtime environments for a smart contract in various languages (Python / JS / etc).
  * `StateStorage` - Holds all state (mutable and immutable) updated for the latest closed block.
  * `JournalStorage` - Holds incremental long-term storage used to generate the state (all past closed blocks).
  * `TimeSync` - Synchronizes clocks, required to run on every machine that runs       *TransactionPool* or *Consensus*.

## Libraries

  * `CryptoLib` - Contains implementations of low-level crypto routines in native (C) with non-native fallbacks.
  * `Client` - Client SDK for apps to connect end-users to the network through the *PublicApi* backend service.

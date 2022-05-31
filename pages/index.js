import Head from 'next/head';
import { useState, useEffect } from "react";
import getWeb3 from "../src/getWeb3";
// Components

// Smart Contracts' ABIs
import SupplyChainContract from '../build/contracts/SupplyChain.json';

export default function Home() {
  // Item State
  const [item, setItem] = useState({
    sku: 0,
    upc: 0,
    ownerID: '0x0',
    originFarmerID: '0x0',
    originFarmName: '',
    originFarmInformation: '',
    originFarmLatitude: '',
    originFarmLongitude: '',
    productNotes: '',
    productPrice: 0,
    distributorID: '0x0',
    retailerID: '0x0',
    consumerID: '0x0',
  });
  // Web3 State
  const [web3State, setWeb3State] = useState({
    web3: null,
    accounts: null,
    contract: null
  });

  useEffect(() => {
    (async () => {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();
      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();
      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = SupplyChainContract.networks[networkId];
      const instance = new web3.eth.Contract(
        SupplyChainContract.abi,
        deployedNetwork && deployedNetwork.address,
      );
      setWeb3State({ web3, accounts, contract: instance })
    })()
  }, []);

  return (
    <div>
      <Head>
        <title>Supply Chain Dapp</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <header className="m-6 flex flex-col items-center justify-center space-y-4">
        <h1 className="text-5xl font-bold">Fair Trade Coffee</h1>
        <p className="text-xl">
          Prove the authenticity of coffee using the Ethereum blockchain.
        </p>
      </header>
    </div>
  )
}

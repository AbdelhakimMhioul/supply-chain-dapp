export default function Button({
	message,
	color,
	dataId,
	web3State,
	item,
	setItem,
}) {
	const harvestItem = async (event) => {
		event.preventDefault();
		if (
			!item.upc ||
			!item.originFarmerID ||
			!item.originFarmName ||
			!item.originFarmInformation ||
			!item.originFarmLatitude ||
			!item.originFarmLongitude ||
			!item.productNotes
		) {
			alert('Farmer and Product Information cannot be empty');
			return;
		}

		alert('Item Harvested');
		return await web3State.contract.methods
			.harvestItem(
				item.upc,
				item.originFarmerID,
				item.originFarmName,
				item.originFarmInformation,
				item.originFarmLatitude,
				item.originFarmLongitude,
				item.productNotes
			)
			.send({ from: web3State.accounts[0] });
	};

	const processItem = async (event) => {
		event.preventDefault();

		alert('Item Processed');
		return await web3State.contract.methods
			.processItem(item.upc)
			.send({ from: web3State.accounts[0] });
	};

	const packItem = async (event) => {
		event.preventDefault();

		alert('Item Packed');
		return await web3State.contract.methods
			.packItem(item.upc)
			.send({ from: web3State.accounts[0] });
	};

	const sellItem = async (event) => {
		event.preventDefault();

		alert('Item Sold');
		const productPrice = web3State.web3.utils.toWei('1', 'ether');

		return await web3State.contract.methods
			.sellItem(item.upc, productPrice)
			.send({ from: web3State.accounts[0] });
	};

	const buyItem = async (event) => {
		event.preventDefault();

		alert('Item Bought');
		const walletValue = web3State.web3.utils.toWei('3', 'ether');
		console.log(walletValue);

		return await web3State.contract.methods.buyItem(item.upc).send({
			from: web3State.accounts[0],
			value: walletValue,
		});
	};

	const shipItem = async (event) => {
		event.preventDefault();

		alert('Item Shipped');
		return await web3State.contract.methods.shipItem(item.upc).send({
			from: web3State.accounts[0],
		});
	};

	const receiveItem = async (event) => {
		event.preventDefault();

		alert('Item Received');
		return await web3State.contract.methods.receiveItem(item.upc).send({
			from: web3State.accounts[0],
		});
	};

	const purchaseItem = async (event) => {
		event.preventDefault();
		const walletValue = web3State.web3.utils.toWei('1', 'ether');

		alert('Item Purchased');
		return await web3State.contract.methods.purchaseItem(item.upc).send({
			from: web3State.accounts[0],
			value: walletValue,
		});
	};

	const fetchItemBufferOne = async () => {
		try {
			const result = await web3State.contract.methods
				.fetchItemBufferOne(item.upc)
				.call();
			setItem({
				sku: result[0],
				upc: result[1],
				ownerID: result[2],
				originFarmerID: result[3],
				originFarmName: result[4],
				originFarmInformation: result[5],
				originFarmLatitude: result[6],
				originFarmLongitude: result[7],
				productNotes: result[8],
				productPrice: result[9],
				distributorID: result[10],
				retailerID: result[11],
				consumerID: result[12],
			});
			return item;
		} catch (error) {
			console.log(error);
		}
	};

	const handleButtonClick = async (event) => {
		event.preventDefault();

		switch (dataId) {
			case 1:
				return await harvestItem(event);
				break;
			case 2:
				return await processItem(event);
				break;
			case 3:
				return await packItem(event);
				break;
			case 4:
				return await sellItem(event);
				break;
			case 5:
				return await buyItem(event);
				break;
			case 6:
				return await shipItem(event);
				break;
			case 7:
				return await receiveItem(event);
				break;
			case 8:
				return await purchaseItem(event);
				break;
			case 9:
				return await fetchItemBufferOne(event);
				break;
		}
	};

	return (
		<button
			id="button"
			type="button"
			onClick={handleButtonClick}
			style={{ backgroundColor: `${color}` }}
			className={`text-white hover:opacity-90 active:scale-95 focus:ring-4 focus:outline-none shadow-lg font-medium rounded-lg text-sm px-5 py-2.5 text-center mr-2 mb-2`}
		>
			{message}
		</button>
	);
}

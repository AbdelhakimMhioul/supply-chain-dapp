export default function InputField({
	labelName,
	value,
	type,
	placeholder,
	onChange,
	name,
	id,
	size,
}) {
	return (
		<div>
			<label className="block text-gray-700 text-sm font-bold mb-2">
				{labelName}
			</label>
			<input
				className="shadow appearance-none border rounded p-2 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
				id={id}
				name={name}
				value={value}
				onChange={onChange}
				type={type}
				size={size}
				placeholder={placeholder}
			/>
		</div>
	);
}

function validate_date(){	
	///ověření že vstup je datum
	const dateLower = document.getElementById('dateLower');
	const dateUpper = document.getElementById('dateUpper');
	const errorElement = document.getElementById('errorBox');
	var error = 0;
	var dateFormat = /^\d{4}\-\d{1,2}\-\d{1,2}$/;
	
	///
	if (dateLower.value.match(dateFormat)) {
		return true;
	} else {
		errorElement.innerText = "Zadané datum není platné. Použijte formát YYYY-MM-DD HH:MM:SS";
		//return false;
		return true; //dočasné
	}
	//chybí dateUpper check
}

function priceCalc(productCount) {
		var finalPrice=0;
		var priceDiv = document.getElementById('priceDiv');
		var productPrices = new Array();
		var productValues = new Array();
		for(var i=0;i<productCount;i++){
			try{
				productPrices[i] = document.getElementById('productPrice'+i).getAttribute('data-value');
			} catch (err){
				productPrices[i] = 0;
			}
			try{
				productValues[i] = document.getElementById('textBox'+i).value;
			} catch (err){
				productValues[i] = 0;
			}
		}
		for(var i=0; i<productCount;i++) {
			finalPrice += productPrices[i]*productValues[i];
		}
		priceDiv.innerText = "Cena: "+finalPrice+" Kč";
}
document.getElementById('search-form').addEventListener('submit', function(event) {
    event.preventDefault();

    const fileInput = document.getElementById('csv-file');
    const file = fileInput.files[0];
    
    if (!file) {
        alert('CSVファイルを選択してください。');
        return;
    }
    
    Papa.parse(file, {
        header: true,
        complete: function(results) {
            const data = results.data;
            const stakerAddresses = data.map(row => row.StakerAddress);
            const amounts = data.map(row => row.Amount);
            const rawData = './id_data.txt';
            
            fetch(rawData)
                .then(response => response.text())
                .then(rawText => {
                    const rawLines = rawText.split('\n');
                    const outputData = [];

                    stakerAddresses.forEach((pattern, index) => {
                        const amount = amounts[index];
                        for (let i = 0; i < rawLines.length; i++) {
                            if (rawLines[i].includes(pattern)) {
                                for (let j = i + 1; j <= i + 40 && j < rawLines.length; j++) {
                                    if (rawLines[j].includes('display:')) {
                                        for (let k = j; k <= i + 40 && k < rawLines.length; k++) {
                                            const match = rawLines[k].match(/Raw:\s*(.*)/);
                                            if (match) {
                                                outputData.push({ stakerAddress: pattern, rawValue: match[1], amount: amount });
                                                break;
                                            }
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    });

                    displayResults(outputData);
                })
                .catch(error => console.error('Error:', error));
        }
    });
});

function displayResults(results) {
    const tbody = document.getElementById('results-table').getElementsByTagName('tbody')[0];
    tbody.innerHTML = ''; // Clear previous results
    
    results.forEach(result => {
        const row = document.createElement('tr');

        const stakerAddressCell = document.createElement('td');
        stakerAddressCell.textContent = result.stakerAddress;
        row.appendChild(stakerAddressCell);

        const rawValueCell = document.createElement('td');
        rawValueCell.textContent = result.rawValue;
        row.appendChild(rawValueCell);

        const amountCell = document.createElement('td');
        amountCell.textContent = result.amount;
        row.appendChild(amountCell);

        tbody.appendChild(row);
    });
}


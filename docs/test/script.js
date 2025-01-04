document.getElementById('search-form').addEventListener('submit', function(event) {
    event.preventDefault();
    
    const pattern = document.getElementById('pattern').value;
    const file = './id_data.txt';
    
    fetch(file)
        .then(response => response.text())
        .then(data => {
            const lines = data.split('\n');
            const results = [];
            
            for (let i = 0; i < lines.length; i++) {
                if (lines[i].includes(pattern)) {
                    for (let j = i + 1; j <= i + 40 && j < lines.length; j++) {
                        if (lines[j].includes('display:')) {
                            for (let k = j; k <= i + 40 && k < lines.length; k++) {
                                const match = lines[k].match(/Raw:\s*(.*)/);
                                if (match) {
                                    results.push({ pattern: pattern, rawValue: match[1] });
                                    break;
                                }
                            }
                            break;
                        }
                    }
                }
            }
            
            displayResults(results);
        })
        .catch(error => console.error('Error:', error));
});

function displayResults(results) {
    const tbody = document.getElementById('results-table').getElementsByTagName('tbody')[0];
    tbody.innerHTML = ''; // Clear previous results
    
    results.forEach(result => {
        const row = document.createElement('tr');
        
        const patternCell = document.createElement('td');
        patternCell.textContent = result.pattern;
        row.appendChild(patternCell);
        
        const rawValueCell = document.createElement('td');
        rawValueCell.textContent = result.rawValue;
        row.appendChild(rawValueCell);
        
        tbody.appendChild(row);
    });
}


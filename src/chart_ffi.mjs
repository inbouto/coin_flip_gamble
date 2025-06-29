import Chart from 'chart.js/auto'
// import { Ok, Error } from "./gleam.mjs"

export function init_chart(element_id, datasets) {
    const ctx = document.getElementById(element_id);
    const formatted_datasets = datasets.map(dataset => ({
        label: dataset[0],
        data: dataset[2].map(row => row.count),
        borderColor: dataset[1]
    }))

    const labels = datasets[0][2].map(row => row.year)

    // const title = dataset[0]
    // const color = dataset[1]
    // const data = dataset[2]

    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: formatted_datasets
        }
    })
}

export function to_data_set(data) {
    return data.map(row => ({year: row[0], count: row[1]}))
}

export function destroy_chart(chart) {
    chart.destroy();
}
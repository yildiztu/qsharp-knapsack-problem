open Microsoft.Quantum.Optimization;

operation SolveKnapsackProblem(qs: Qubit[]) : Unit {
    let numItems = 10;
    let itemValues = [5, 10, 20, 30, 40, 50, 60, 70, 80, 90];
    let itemWeights = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    let capacity = 15;

    // Define the objective function
    let f(x: Double[]) : Double {
        let totalValue = 0.0;
        for (i in 0..numItems - 1) {
            totalValue += x[i] * itemValues[i];
        }
        return totalValue;
    }

    // Define the constraints
    let constraints = new (Double[], Double)[1];
    let weightConstraint = new Double[numItems];
    for (i in 0..numItems - 1) {
        weightConstraint[i] = itemWeights[i];
    }
    constraints[0] = (weightConstraint, capacity);

    // Set the bounds of the variables
    let bounds = new (Double, Double)[numItems];
    for (i in 0..numItems - 1) {
        bounds[i] = (0.0, 1.0);
    }

    // Define the initial state
    let initialState = new Double[numItems];
    for (i in 0..numItems - 1) {
        initialState[i] = 0.0;
    }

    // Run the optimization
    let result = Minimize(f, constraints, bounds, initialState, qs);
    let schedule = result.ArgMin;

    // Print the results
    let selectedItems = [for (i in 0..numItems - 1) if (schedule[i] > 0.5) i];
    Message($"Selected items: {selectedItems} with total value: {result.MinValue}.");
}

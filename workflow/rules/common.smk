samples = (
    pd.read_csv(
        config["samples"],
        sep="\t",
        dtype={"sample": str, "fq1": str, "fq2": str},
        comment="#",
    )
    .set_index("sample", drop=False)
    .sort_index()
)

# def get_input_fastqs(wildcards):
#    return config["samples"][wildcards.sample]

SAMPLE = samples["sample"].tolist()


# List of sample names
sample_names = SAMPLE

square_root = math.sqrt(len(sample_names))
rounded_square_root = math.ceil(square_root)

# Adjust to the nearest odd number
if rounded_square_root % 2 == 0:
    rounded_square_root += 1

# Create a matrix with dimensions (rounded_square_root) x (rounded_square_root)
matrix = [["" for _ in range(rounded_square_root)] for _ in range(rounded_square_root)]

# Fill the matrix with sample names
for i in range(min(len(sample_names), (rounded_square_root) ** 2)):
    row_index = i // (rounded_square_root)
    col_index = i % (rounded_square_root)
    matrix[row_index][col_index] = sample_names[i]

arr = np.array(matrix)

input_df = pd.DataFrame({"sample_list": arr.tolist()})

new_df = pd.DataFrame({"sample_list": arr.T.tolist()})

input_df = pd.concat([input_df, new_df], ignore_index=True)

# Get the number of rows and columns
num_rows, num_cols = arr.shape

# Perform the shifting operation num_rows - 1 times
for _ in range(num_rows - 1):
    shifted_matrix = np.empty_like(arr, dtype=object)
    for i in range(num_rows):
        shifted_matrix[i, :] = np.roll(arr[i, :], i)

    # print(f"\nShifted Matrix ({_ + 1} times):")
    # print(shifted_matrix)

    # Update the original matrix for the next iteration
    arr = shifted_matrix.copy()
    new_df = pd.DataFrame({"sample_list": arr.T.tolist()})
    input_df = pd.concat([input_df, new_df], ignore_index=True)


# Function to remove empty strings from a list
def clean_list(original_list):
    return ["results/skf_files/" + item + ".skf" for item in original_list if item != ""]


input_df["sample_list"] = input_df["sample_list"].apply(clean_list)

input_df["iteration"] = "iteration" + input_df.index.astype(str)

input_df.set_index('iteration', inplace=True, drop=False)

distance_files = ["results/distances/" + item + ".distances.tsv" for item in input_df.loc[:, "iteration"]]

wildcard_constraints:
    sample="|".join(samples["sample"]),
    iteration="|".join(input_df["iteration"]),

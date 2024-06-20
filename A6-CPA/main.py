from pandas import DataFrame
import numpy as np
import scipy.io
import scipy.stats as sci
import matplotlib.pyplot as plt
import seaborn as sns
from typing import List


Sbox = [0xC, 0x5, 0x6, 0xB, 0x9, 0x0, 0xA, 0xD, 0x3, 0xE, 0xF, 0x8, 0x4, 0x7, 0x1, 0x2]

key_length = 16
timesteps = 6990 #no of columns in traces_arr

# For all possible key candidates k ∈ {0,1,...,255}, compute the column-wise 
def create_value_power_matrix(in_arr, VP, PP) -> float:

    for i in range(0,len(in_arr)):
        # as range is not inclusive the value of k will be from, 16 is the possible number of inputs for sbox as it is 4*4
        for j in range(key_length): 

            k = j # removed j-1 as the loop is starting from 0
            # Create a value prediction matrix 
            VP[i][j] = Sbox[in_arr[i] ^ k]
            # Computer Humming weight of the VP matrix - Power Prediction Matrix
            # temp = VP[i][j]
            PP[i][j] = bin(VP[i][j]).count("1")

    return(PP)

# correlation between the traces matrix and the power-prediction matrix.
def compute_correlation(traces_arr, PP):

    scores = np.empty((timesteps, key_length), dtype='f16')

    # print(scores.shape, traces_arr.shape, PP.shape)

    for i in range(0, timesteps):
        for j in range(0, key_length):
            scores[i,j] = abs(np.corrcoef(traces_arr[:,i], PP[:,j])[1,0])
    return scores

# Demonstrate the top candidate based on absolute correlation.
def compute_key_score(scores):  
    key_scores = []
    for j in range(0, key_length):
        key_scores.append(max(scores[:,j]))

    # print(key_score)
   
    return key_scores

# Rank the key candidates from best to worst, based on the absolute value 
def compute_best_key_candidate(key_score):
    max_score = key_score[0]
    max_index = 0
    for i in range(0, len(key_score)):    
        if(key_score[i] > max_score):    
            max_score = key_score[i]
            max_index = i    
    print("\nKey with maximum score for current attack: ", max_index)

    return max_index


# Graph-1: For every time sample, plot the absolute correlation value for every key candidate. Highlight the top candidate
def plot_correlations(cc:float, key_index:int) -> None:
 
    df = DataFrame(cc)
    plt.ylim(-0.02,0.6)

    plt.xlabel('Time')
    plt.ylabel('Correlation')
    plt.title('Correlation between traces and PP')
    plt.plot(df.loc[:,0:5:1], color='gray' )
    plt.plot(df.loc[:,7:15:1], color='gray' )
    plt.plot(df[6], marker='', color='green')
    plt.savefig("graphs/{key_index}-Correlation.png".format(key_index=key_index))
    
    print("Done plotting\n")


# Graph-2: Create the following graph: Run the attack with 500, 1k, 2k 4k, 8k and 12k power traces and for every attack, rank the candidates from best to worst (based on the absolute correlation value). Focus on the correct candidate, i.e. the one you recovered previously using 14900 traces. Plot the correct candidate's ranking (e.g. 1st, 2nd etc.) for all these attacks.

def plot_rank_attacks(df) -> None:

    plt = sns.lineplot(data=df)
    plt.set(xlabel='No of traces', ylabel='Rank')
    plt.plot(df, marker='*', color='green')
    fig = plt.get_figure()
    import time
    fig.savefig("graphs/{ts}-attacks.png".format(ts = time.time()))


def execute_attack(in_arr, traces_arr, no_of_traces) -> None:

    VP = PP = np.zeros((no_of_traces, key_length), dtype=np.int16)

    PP = create_value_power_matrix(in_arr, VP, PP)
    scores = compute_correlation(traces_arr, PP)
    key_scores = compute_key_score(scores)

    # best_key_candidate = compute_best_key_candidate(key_scores)
    
    # if (best_key_candidate == 6):
    #     plot_correlations(scores, best_key_candidate)

    return key_scores


def plan_attacks() -> None:

    in_arr = np.asarray(scipy.io.loadmat('in.mat')['in']).flatten() # shape: (14900,)
    traces_arr = scipy.io.loadmat('traces.mat')['traces'] # shape:(14900, 6990)

    # # Full attack, for plotting correlation 
    # execute_attack(in_arr, traces_arr)

    key_rank = [0] * 6
    # 1st attack
    no_of_traces = 500 
    key_score = execute_attack(in_arr[0:no_of_traces], traces_arr[0:no_of_traces,:], no_of_traces)
    key_rank.append(16 - (sci.rankdata(key_score)[6]) + 1)

    # 2nd attack
    no_of_traces = 1000
    key_score = execute_attack(in_arr[0:no_of_traces], traces_arr[0:no_of_traces,:], no_of_traces)
    key_rank.append(16 - (sci.rankdata(key_score)[6]) + 1)

    # 3rd attack
    no_of_traces = 2000
    key_score = execute_attack(in_arr[0:no_of_traces], traces_arr[0:no_of_traces,:],no_of_traces)
    key_rank.append(16 - (sci.rankdata(key_score)[6]) + 1)

    # 4th attack
    no_of_traces = 4000  
    key_score = execute_attack(in_arr[0:no_of_traces], traces_arr[0:no_of_traces,:], no_of_traces)
    key_rank.append(16 - (sci.rankdata(key_score)[6]) + 1)
    
    # 5th attack
    no_of_traces = 8000
    key_score = execute_attack(in_arr[0:no_of_traces], traces_arr[0:no_of_traces,:],no_of_traces)
    key_rank.append(16 - (sci.rankdata(key_score)[6]) + 1)

    # 6th attack
    no_of_traces = 12000
    key_score = execute_attack(in_arr[0:no_of_traces], traces_arr[0:no_of_traces,:], no_of_traces)
    key_rank.append(16 - (sci.rankdata(key_score)[6]) + 1)
    
    # print(key_rank)
    # Correct key's rank = [15.0, 16.0, 15.0, 9.0, 2.0, 1.0]
    data = {'6th Keys ranks': [15, 16, 15, 9, 2, 1]}
    df = DataFrame(data, index = [500, 1000, 2000, 4000, 8000, 12000] )

    # print(df)
    plot_rank_attacks(df)

plan_attacks()

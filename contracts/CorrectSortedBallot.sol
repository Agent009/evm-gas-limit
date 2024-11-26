// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CorrectSortedBallot {
    struct Proposal {
        bytes32 name;
        uint256 voteCount;
    }

    // State variables
    Proposal[] public proposals;
    Proposal[] public proposalsBeingSorted;
    uint256 public swaps;
    uint256 public sortedWords; // to check if we've finished sorting
    uint256 public savedIndex;

    constructor(bytes32[] memory proposalNames) {
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
        savedIndex = 1;
        proposalsBeingSorted = proposals;
    }

    function restartSorting() public {
        swaps = 0;
        sortedWords = 0;
        savedIndex = 1;
        proposalsBeingSorted = proposals;
    }

    function sortProposals(uint256 steps) public returns (bool) {
        uint256 step = 0;
        while (sortedWords < proposalsBeingSorted.length) {
            if (step >= steps) return (false);

            if (savedIndex >= proposalsBeingSorted.length) {
                // We are at the end of the array
                sortedWords = proposalsBeingSorted.length - swaps;
                swaps = 0;
                savedIndex = 1;
            } else {
                Proposal memory prevObj = proposalsBeingSorted[savedIndex - 1];
                // We are not at the end of the array
                if (
                    uint256(prevObj.name) >
                    uint256(proposalsBeingSorted[savedIndex].name)
                ) {
                    proposalsBeingSorted[savedIndex - 1] = proposalsBeingSorted[
                        savedIndex
                    ];
                    proposalsBeingSorted[savedIndex] = prevObj;
                    swaps++;
                }
                savedIndex++;
            }
            step++;
        }
        proposals = proposalsBeingSorted;
        return (true);
    }

    function sorted() public view returns (bool isSorted) {
        isSorted = sortedWords == proposals.length;
    }
}

import java.util.List;
import java.util.LinkedList;

class QuickSorter implements Sorter {
	
/**

function quicksort(array, left, right)

  // If the list has 2 or more items
  if left < right

	  // See "Choice of pivot" section below for possible choices
	  choose any pivotIndex such that left ≤ pivotIndex ≤ right

	  // Get lists of bigger and smaller items and final position of pivot
	  pivotNewIndex := partition(array, left, right, pivotIndex)

	  // Recursively sort elements smaller than the pivot
	  quicksort(array, left, pivotNewIndex - 1)

	  // Recursively sort elements at least as big as the pivot
	  quicksort(array, pivotNewIndex + 1, right)
 **/
	public List<Instruction> plan(int[] items) {
		List<Instruction> steps = new LinkedList<Instruction>();
		if(items.length < 2) {
			return steps;
		}
		int left = 0, right = items.length-1;
		// pick a point in the middle;
		int pivot = items.length/2;
		int nextPivot = partition(steps, items, left, right, pivot);
		quicksort(steps, items, left, nextPivot-1);
		quicksort(steps, items, nextPivot+1, right);
		return steps;
	}

	private void quicksort(List<Instruction> steps, int[] items, int left, int right) {
		if(left < right) {
			int pivot = left + (right - left)/2;
			int nextPivot = partition(steps, items, left, right, pivot);
			quicksort(steps, items, left, nextPivot-1);
			quicksort(steps, items, nextPivot+1, right);
		}
	}

/**
// left is the index of the leftmost element of the subarray
// right is the index of the rightmost element of the subarray (inclusive)
//   number of elements in subarray = right-left+1
function partition(array, left, right, pivotIndex)
  pivotValue := array[pivotIndex]
  swap array[pivotIndex] and array[right]  // Move pivot to end
  storeIndex := left
  for i from left to right - 1  // left ≤ i < right
	  if array[i] < pivotValue
		  swap array[i] and array[storeIndex]
		  storeIndex := storeIndex + 1
  swap array[storeIndex] and array[right]  // Move pivot to its final place
  return storeIndex
**/
	private int partition(List<Instruction> steps, int[] items, int left, int right, int pivot) {
		int pivotValue = items[pivot];
		swap(items, pivot, right);
		steps.add(new InstructionImpl(pivot, right, true, new int[] {left, right}));
		int storeIndex = left;
		for(int i = left; i < right; i++) {
			if(items[i] < pivotValue) {
				if(i != storeIndex) {
					swap(items, i, storeIndex);
					steps.add(new InstructionImpl(i, storeIndex, true, new int[] {left, right}));
				}
				storeIndex++;
			}
			else {
				if(i != pivot) {
					steps.add(new InstructionImpl(i, pivot, false, new int[] {left, right}));
				}
			}
		}
		swap(items, storeIndex, right);
		steps.add(new InstructionImpl(storeIndex, right, true, new int[] {left, right}));
		return storeIndex;
	}

	private void swap(int[] items, int i, int j) {
		int tmp = items[i];
		items[i] = items[j];
		items[j] = tmp;
	}
}

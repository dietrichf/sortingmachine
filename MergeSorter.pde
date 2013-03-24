import java.util.LinkedList;
import java.util.Arrays;

class MergeSorter implements Sorter {

	List<Step> plan(int[] array) {
		List<Step> steps = new LinkedList<Step>();
		mergeSort(steps, array, 0);
		return steps;
	}

	void mergeSort(List<Step> steps, int[] array, int offset) {
		if (array.length <= 1) return;
		int[] a0 = Arrays.copyOfRange(array, 0, array.length/2);
		int[] a1 = Arrays.copyOfRange(array, array.length/2, array.length);
		mergeSort(steps, a0, offset);
		mergeSort(steps, a1, offset + array.length/2);
		merge(steps, a0, a1, array, offset);
	}

	void merge(List<Step> steps, int[] a0, int[] a1, int[] a, int offset) {
		int i0 = 0, i1 = 0;
		for (int i = 0; i < a.length; i++) {
			if (i0 == a0.length) {
				a[i] = a1[i1];
				i1++;
			}
			else if (i1 == a1.length) {
				a[i] = a0[i0];
				i0++;
			}
			else if (a0[i0] < a1[i1]) {
				a[i] = a0[i0];
				i0++;
			}
			else {
				a[i] = a1[i1];
				i1++;
			}
		}
	}
}

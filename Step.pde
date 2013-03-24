class Step implements IStep {

	private int lo, hi;
	private boolean swap;
	private int[] controlPoints;

	Step(int lo, int hi, boolean swap, int[] controlPoints) {
		this.lo = lo;
		this.hi = hi;
		this.swap = swap;
		this.controlPoints = controlPoints;
	}

	public int lo() {
		return this.lo;
	}

	public int hi() {
		return this.hi;
	}

	public boolean swap() {
		return this.swap;
	}

	public int[] controlPoints() {
		return this.controlPoints;
	}
	
	public boolean isControlPoint(int n) {
		if(controlPoints == null || controlPoints.length == 0) {
			return false;
		}
		for(int i = 0; i < controlPoints.length; i++) {
			if(controlPoints[i] == n) {
				return true;
			}
		}
		return false;
	}

	public void exec(int[] array) {
		if(swap()) {
			int tmp = array[lo];
			array[lo] = array[hi];
			array[hi] = tmp;
		}
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("compared positions ")
		  .append(lo)
		  .append(" and ")
		  .append(hi)
		  .append(", swap = ")
		  .append(swap);
		return sb.toString();
	}
}

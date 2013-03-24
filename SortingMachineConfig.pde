class SortingMachineConfig {

	private boolean animated;
	private WindowConfig window;
	private RunStepConfig[] runList;

	public SortingMachineConfig(Map<String, Object> in) {
		this.animated = (Boolean)in.get("animated");
		this.window = new WindowConfig((Map<String, Object>)in.get("window"));
	}


	public boolean isAnimated() {
		return this.animated;
	}
	
	public void setAnimated(boolean animated) {
		this.animated = animated;
	}

	public WindowConfig getWindow() {
		return this.window;
	}

	public void setWindow(WindowConfig window) {
		this.window = window;
	}

	public RunStepConfig[] getRunList() {
		return this.runList;
	}

	public void setRunList(RunStepConfig[] runList) {
		this.runList = runList;
	}

	public String toString() {
		return Objects.toStringHelper(this)
			.add("animated", animated)
			.toString();
	}
}

class RunStepConfig {

	private String label;
	private String sort;
	private String dataRef;

	public String getLabel() {
		return this.label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public String getDataRef() {
		return dataRef;
	}

	public void setDataRef(String dataRef) {
		this.dataRef = dataRef;
	}
}

class DataConfig {
	private String label;
	private int[] values;
	private RandomDataConfig randomData;
}

class RandomDataConfig {
	private int size;
	private int[] uniqueValues;
	public void setSize() {
		this.size = size;
	}
	public int getSize() {
		return this.size;
	}
	public void setUniqueValues(int[] uniqueValues) {
		this.uniqueValues = uniqueValues;
	}
	public int[] getUniqueValues() {
		return this.uniqueValues;
	}
}

class WindowConfig {

	private int width;
	private int height;
	private int leftMargin;
	private int rightMargin;
	private int topMargin;
	private int bottomMargin;

	public WindowConfig(Map<String, Object> in) {
		this.width = (Integer)in.get("width");
		this.height = (Integer)in.get("height");
	}

	public int getWidth() { return this.width; } 
	public void setWidth(int width) { this.width = width; }
	public int getHeight() { return this.height; }
	public void setHeight(int height) { this.height = height; }

	public void setMargins(int[] margins) {
		if(margins.length != 4) {
			throw new RuntimeException("margin should be size = 4");
		}
		topMargin = margins[0];
		rightMargin = margins[1];
		bottomMargin = margins[2];
		leftMargin = margins[3];
	}
}


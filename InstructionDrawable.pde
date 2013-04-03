class InstructionDrawable implements Drawable {
	
	private float x, y;
	private final float noteHeight;
	private final float noteWidth;
	private boolean executing;

	private final Instruction instruction;

	private final int[] a;

	public InstructionDrawable(Instruction instruction, float noteHeight, float noteWidth, int[] a) {
		this.instruction = instruction;
		this.noteHeight = noteHeight;
		this.noteWidth = noteWidth;
		this.a = a;
	}

	public void place(Point p) {
		this.x = p.x;
		this.y = p.y;
	}

	public float getWidth() {
		return noteWidth;
	}

	public float getHeight() {
		return noteHeight * (float)a.length;
	}

	public void setup() { }

	public void tick() { }

	public void draw() {
		pushMatrix();
		translate(x, y);
		if(executing) {
			pushStyle();
			fill(255,255,0,50);
			noStroke();
			rect(0,0,noteWidth,noteHeight * a.length);
			popStyle();
		}
		for(int i = 0; i < a.length; i++) {
			float noteY = i * noteHeight;
			pushStyle();
			if(instruction.isControlPoint(i) && !instruction.isBeingSwapped(i)) {
				stroke(15,59,160,100);
				line(0, noteY, noteWidth-1f, noteY);
			}
			else {
				// set up stroke style based on whether there was a
				// 1 - swap
				// 2 - compare
				// 3 - nothing
				if(i == instruction.hi() || i == instruction.lo()) {
					// either a swap or a compare
					if(instruction.swap()) {
						// draw swaps in bold
						stroke(0,0,0,255);
					}
					else {
						// draw compares in red
						stroke(255,0,0,200);
					}
				}
				else {
					// lightly draw idle positions
					stroke(0,0,0,30);
				}
				if(instruction.swap()) {
					if(i == instruction.hi()) {
						float endY = instruction.lo() * noteHeight;
						// curve to instruction.lo()
						noFill();
						beginShape();
						vertex(0, noteY);
						bezierVertex(noteWidth/2f, noteY, noteWidth/2f, endY, noteWidth, endY);
						endShape();
					}
					else if(i == instruction.lo()) {
						// don't draw
					}
					else {
						line(0, noteY, noteWidth-1f, noteY);
					}
				}
				else {
					// not a swap
					line(0, noteY, noteWidth-1f, noteY);
				}
			}
			popStyle();
		}
		popMatrix();
	}

	public void setExecuting(boolean b) {
		this.executing = b;
	}
}

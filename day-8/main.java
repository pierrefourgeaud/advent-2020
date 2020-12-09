import java.util.ArrayList;
import java.util.Scanner;

enum ProcessedType {
  NONE,
  NORMAL,
  FORK
}

abstract class Instruction {
  protected int value;
  protected ProcessedType processed;

  public boolean processed(boolean isFork) {
    return isFork ? this.processed != ProcessedType.NONE :
                    this.processed == ProcessedType.NORMAL;
  }

  public void setProcessed(ProcessedType value) {
    this.processed = value;
  }

  public abstract int execute(BootSequence boot, int index);

  public Instruction getAlternativeInstruction() {
    return InstructionFactory.createInstruction("nop", 0);
  }

  public boolean forkable() {
    return false;
  }
}

class NopInstruction extends Instruction {
  private int value;

  public NopInstruction(int value) {
    this.value = value;
    this.processed = ProcessedType.NONE;
  }

  @Override
  public int execute(BootSequence boot, int index) {
    // Noop
    return index;
  }

  @Override
  public Instruction getAlternativeInstruction() {
    return InstructionFactory.createInstruction("jmp", this.value);
  }

  @Override
  public boolean forkable() {
    return true;
  }
}

class AccInstruction extends Instruction {
  private int value;

  public AccInstruction(int value) {
    this.value = value;
    this.processed = ProcessedType.NONE;
  }

  @Override
  public int execute(BootSequence boot, int index) {
    boot.addValue(this.value);
    return index;
  }
}

class JmpInstruction extends Instruction {
  public JmpInstruction(int value) {
    this.value = value;
    this.processed = ProcessedType.NONE;
  }

  @Override
  public int execute(BootSequence boot, int index) {
    // The -1 is stupid and should not belong here... The jmp instruction
    // shouldn't know that it is execute in a loop, so why should it care
    // about the offset by one?
    return index + this.value - 1;
  }

  @Override
  public Instruction getAlternativeInstruction() {
    return InstructionFactory.createInstruction("nop", this.value);
  }

  @Override
  public boolean forkable() {
    return true;
  }
}

class InstructionFactory {
  public static Instruction createInstructionFromString(String instruction) {
    String[] tmp = instruction.split(" ", 0);

    if (tmp[0].equals("acc")) {
      return new AccInstruction(Integer.parseInt(tmp[1]));
    } else if (tmp[0].equals("jmp")) {
      return new JmpInstruction(Integer.parseInt(tmp[1]));
    } else if (tmp[0].equals("nop")) {
      return new NopInstruction(Integer.parseInt(tmp[1]));
    }

    return new NopInstruction(0);
  }

  public static Instruction createInstruction(String instructionName, int value) {
    if (instructionName.equals("acc")) {
      return new AccInstruction(value);
    } else if (instructionName.equals("jmp")) {
      return new JmpInstruction(value);
    } else if (instructionName.equals("nop")) {
      return new NopInstruction(value);
    }

    return new NopInstruction(0);
  }
}

class BootSequence {
  private ArrayList<Instruction> instructions;
  private int value;

  public BootSequence() {
    this.instructions = new ArrayList<Instruction>();
    this.value = 0;
  }

  public void addInstruction(Instruction instruction) {
    this.instructions.add(instruction);
  }

  public void execute(boolean withFix) {
    executeFromIndex(0, withFix, false);
  }

  private boolean executeFromIndex(int index, boolean withFix, boolean forked) {
    if (index < 0 || index >= this.instructions.size()) {
      return false;
    }

    for (int i = index; i < this.instructions.size(); ++i) {
      if (this.instructions.get(i).processed(forked)) {
        return false;
      }

      this.instructions.get(i).setProcessed(
        forked ? ProcessedType.FORK : ProcessedType.NORMAL
      );

      
      if (withFix && this.instructions.get(i).forkable()) {
        boolean forkRes = this.fork(i);
        if (forkRes) {
          return true;
        }
      }
      i = this.instructions.get(i).execute(this, i);
    }

    return true;
  }

  private boolean fork(int index) {
    // save value before the fork
    int oldValue = this.value;
    // save the instruction before the fork
    Instruction oldIns = this.instructions.get(index);

    Instruction newIns = oldIns.getAlternativeInstruction();
    this.instructions.set(index, newIns);
    int newIndex = newIns.execute(this, index);
    boolean res = this.executeFromIndex(newIndex + 1, false, true);

    if (!res) {
      // Restore the value if the fork failed
      this.value = oldValue;
      // Restore the instruction if the fork failed
      this.instructions.set(index, oldIns);
    }

    return res;
  }

  public void reset() {
    this.value = 0;
    this.instructions.forEach((i) -> i.setProcessed(ProcessedType.NONE));
  }

  public int getValue() {
    return this.value;
  }

  public void addValue(int toAdd) {
    this.value += toAdd;
  }
}

class Main {
  public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);

    BootSequence boot = new BootSequence();

    while (scanner.hasNext()) {
      Instruction i = InstructionFactory.createInstructionFromString(scanner.nextLine());
      boot.addInstruction(i);
    }
    scanner.close();

    boot.execute(false);
    System.out.println("Part 1: " + boot.getValue());

    boot.reset();

    boot.execute(true);
    System.out.println("Part 2: " + boot.getValue());
  }
}
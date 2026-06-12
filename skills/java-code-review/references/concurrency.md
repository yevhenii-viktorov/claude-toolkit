# Concurrency

Sources: Effective Java Items 78–84, *Java Concurrency in Practice*, JLS memory model. Concurrency bugs are non-deterministic — they pass tests and fail in production. Review shared mutable state with suspicion.

## Shared mutable state (Item 78)

The root of most concurrency bugs: two threads access the same mutable data and at least one writes, without synchronization.

- A field mutated by one thread and read by another **without** `synchronized`/`volatile`/`Atomic*` has no happens-before guarantee — the reader may see a stale or torn value (long/double writes aren't atomic without `volatile`).
- A non-thread-safe object (`HashMap`, `ArrayList`, `SimpleDateFormat`, `SimpleDateFormat` especially) shared across threads → corruption. `SimpleDateFormat`/`Calendar` are notoriously not thread-safe; use `java.time` (`DateTimeFormatter` is immutable/thread-safe).
- A mutable field on a **shared singleton** (Spring `@Service`/`@Component`, a static instance) mutated per-request is a classic data race. Singletons must be stateless or use thread-safe state.

## `volatile`, `synchronized`, atomics (Items 78–79)

- `volatile` gives visibility (and ordering) but **not** atomicity for compound actions — `volatile int n; n++;` is still a race (read-modify-write). Use `AtomicInteger.incrementAndGet()`.
- `synchronized` gives both, but hold locks as briefly as possible; never call alien/overridable methods while holding a lock (deadlock/reentrancy risk, Item 79).
- Prefer `java.util.concurrent` over hand-rolled `wait`/`notify` (Item 81): `AtomicX`, `ConcurrentHashMap`, `CountDownLatch`, `Semaphore`, `BlockingQueue`, `ConcurrentHashMap.computeIfAbsent`.
- Document a class's thread-safety (Item 82): thread-safe / conditionally / not. A reviewer should know the contract.

## Double-checked locking & lazy init (Item 83)

The classic broken DCL omits `volatile`:

```java
private Helper helper;                          // BUG without volatile
Helper get() {
    if (helper == null) {
        synchronized (this) {
            if (helper == null) helper = new Helper();  // other threads may see partially-constructed
        }
    }
    return helper;
}
```

Fix: make `helper` `volatile`, or use the **holder idiom** (static nested class, lazily initialized by the classloader — no synchronization needed), or just initialize eagerly if cheap.

## `ExecutorService` lifecycle

- An `ExecutorService` that's created but never `shutdown()` leaks threads (non-daemon threads also block JVM exit). Shut it down (often in a `finally` or lifecycle hook), and consider `awaitTermination`.
- Don't swallow `InterruptedException` — restore the flag (`Thread.currentThread().interrupt()`) or propagate. Eating it breaks cancellation. SpotBugs-adjacent; Item 80.
- Submitting to a pool and ignoring the returned `Future` discards exceptions thrown by the task — they vanish silently.

## Virtual threads (Java 21)

- Virtual threads (`Thread.ofVirtual()`, `Executors.newVirtualThreadPerTaskExecutor()`) are for **blocking I/O-bound** work — one per task, cheap. Don't pool them like platform threads.
- **Pinning**: a virtual thread blocked inside a `synchronized` block pins its carrier thread, defeating the benefit. For virtual-thread code paths, prefer `ReentrantLock` over `synchronized` around blocking calls.
- Don't use virtual threads for CPU-bound work — no advantage over a bounded platform pool.

## Other hazards

- **Deadlock** — acquiring two locks in inconsistent order across code paths. Establish and document a lock ordering.
- **Copied `synchronized` on a non-final lock field** — synchronizing on a field that gets reassigned means threads lock different objects. Lock on a `private final` object.
- **`ThreadLocal`** not cleaned up in a pooled-thread context (web container) leaks memory and bleeds state across requests — `remove()` in a `finally`.
- Tests of concurrent code that "pass" prove little; flag concurrency changes with no stress/repeat test, but don't demand exhaustive race tests on simple code.

## Quick scan

- Mutable field shared across threads without sync/volatile/atomic.
- Mutable state on a Spring singleton / static instance.
- `SimpleDateFormat`/`Calendar` shared across threads.
- `volatile` counter incremented (`n++`) — needs atomic.
- DCL without `volatile`.
- `ExecutorService` never `shutdown()`; swallowed `InterruptedException`; ignored `Future`.
- Virtual thread blocking inside `synchronized` (pinning).
- `synchronized` on a non-final / reassigned field.
- `ThreadLocal` without `remove()` in pooled threads.

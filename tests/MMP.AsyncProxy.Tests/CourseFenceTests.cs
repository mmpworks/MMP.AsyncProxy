using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Xunit;
using Xunit.Abstractions;

namespace MMP.AsyncProxy.Tests
{
    /// <summary>
    /// Anchor for the written word. Every C# block in the course, the SDK guide, and the
    /// training READMEs is either this repo's own code or is marked as a sketch. A reader
    /// who copies a block gets code that exists, compiles, and is under test.
    ///
    /// The check is line-based: each code line of a fence (comments, blank lines, and
    /// brace-only lines skipped, whitespace collapsed) must appear in some .cs file under
    /// src/, samples/, tests/, or training/. A fence passes at 90 percent of its lines, so
    /// an excerpt may drop a line or two of the original. A fence that is meant as a sketch
    /// (modern async/await for comparison, decompiler output, an exercise with a bug in it)
    /// carries an HTML comment on the line above it, invisible on GitHub:
    /// <c>&lt;!-- fence: sketch why --&gt;</c>.
    /// </summary>
    public class CourseFenceTests
    {
        private const double PassRatio = 0.9;
        private static readonly Regex SketchMarker = new Regex(@"^<!--\s*fence:\s*sketch\b(?<reason>[^>]*)-->\s*$", RegexOptions.Compiled);
        private static readonly string[] DocGlobs = { "docs/course", "docs/sdk.md", "training" };

        private readonly ITestOutputHelper _out;
        public CourseFenceTests(ITestOutputHelper output) { _out = output; }

        [Fact]
        public void Every_csharp_fence_is_repo_code_or_a_marked_sketch()
        {
            string root = RepoRoot.Find();
            HashSet<string> corpus = SourceLines(root);
            List<Fence> fences = Fences(root).ToList();
            Assert.True(fences.Count >= 60, "expected to find the course fences; found " + fences.Count);

            var failures = new List<string>();
            foreach (Fence fence in fences)
            {
                if (fence.Sketch) { _out.WriteLine("sketch  " + fence.Where + "  " + fence.Reason); continue; }
                string[] code = fence.CodeLines();
                int hit = code.Count(corpus.Contains);
                double ratio = code.Length == 0 ? 1.0 : (double)hit / code.Length;
                string line = string.Format("{0,5:P0}  {1}  ({2}/{3})", ratio, fence.Where, hit, code.Length);
                _out.WriteLine(line);
                if (ratio < PassRatio)
                {
                    string missing = string.Join(" | ", code.Where(l => !corpus.Contains(l)).Take(3).ToArray());
                    failures.Add(line + "  first misses: " + missing);
                }
            }
            Assert.True(failures.Count == 0, failures.Count + " fence(s) are neither repo code nor marked as a sketch:\n" + string.Join("\n", failures.ToArray()));
        }

        [Fact]
        public void Every_sketch_marker_gives_a_reason()
        {
            string root = RepoRoot.Find();
            var bare = Fences(root).Where(f => f.Sketch && f.Reason.Length == 0).Select(f => f.Where).ToList();
            Assert.True(bare.Count == 0, "sketch markers with no reason:\n" + string.Join("\n", bare.ToArray()));
        }

        private static IEnumerable<Fence> Fences(string root)
        {
            foreach (string file in DocFiles(root))
            {
                string[] lines = File.ReadAllLines(file);
                for (int i = 0; i < lines.Length; i++)
                {
                    if (lines[i].TrimStart() != "```csharp") continue;
                    int start = i + 1;
                    int end = start;
                    while (end < lines.Length && lines[end].TrimStart() != "```") end++;
                    string above = i > 0 ? lines[i - 1].Trim() : "";
                    Match marker = SketchMarker.Match(above);
                    yield return new Fence
                    {
                        Where = Relative(root, file) + ":" + (i + 1),
                        Lines = lines.Skip(start).Take(end - start).ToArray(),
                        Sketch = marker.Success,
                        Reason = marker.Success ? marker.Groups["reason"].Value.Trim() : "",
                    };
                    i = end;
                }
            }
        }

        private static IEnumerable<string> DocFiles(string root)
        {
            foreach (string glob in DocGlobs)
            {
                string path = Path.Combine(root, glob.Replace('/', Path.DirectorySeparatorChar));
                if (File.Exists(path)) { yield return path; continue; }
                foreach (string md in Directory.GetFiles(path, "*.md", SearchOption.AllDirectories))
                    if (!md.Contains(Path.DirectorySeparatorChar + "bin" + Path.DirectorySeparatorChar) &&
                        !md.Contains(Path.DirectorySeparatorChar + "obj" + Path.DirectorySeparatorChar))
                        yield return md;
            }
        }

        private static HashSet<string> SourceLines(string root)
        {
            var set = new HashSet<string>(StringComparer.Ordinal);
            foreach (string dir in new[] { "src", "samples", "tests", "training" })
            {
                string path = Path.Combine(root, dir);
                foreach (string cs in Directory.GetFiles(path, "*.cs", SearchOption.AllDirectories))
                {
                    if (cs.Contains(Path.DirectorySeparatorChar + "bin" + Path.DirectorySeparatorChar) ||
                        cs.Contains(Path.DirectorySeparatorChar + "obj" + Path.DirectorySeparatorChar)) continue;
                    foreach (string raw in File.ReadAllLines(cs))
                    {
                        string norm = Fence.Normalize(raw);
                        if (norm != null) set.Add(norm);
                    }
                }
            }
            return set;
        }

        private static string Relative(string root, string file)
        {
            return file.Substring(root.Length).TrimStart('\\', '/').Replace('\\', '/');
        }

        private sealed class Fence
        {
            private static readonly Regex Spaces = new Regex(@"\s+", RegexOptions.Compiled);
            private static readonly Regex TrailingComment = new Regex(@"\s//.*$", RegexOptions.Compiled);
            private static readonly Regex Punctuation = new Regex(@"^[{}();,\s]*$", RegexOptions.Compiled);

            public string Where;
            public string[] Lines;
            public bool Sketch;
            public string Reason;

            public string[] CodeLines()
            {
                return Lines.Select(Normalize).Where(l => l != null).ToArray();
            }

            /// <summary>One canonical spelling of a code line, or null when the line carries no code.</summary>
            public static string Normalize(string raw)
            {
                string s = raw.Trim();
                if (s.Length == 0) return null;
                if (s.StartsWith("//") || s.StartsWith("///") || s.StartsWith("#") || s.StartsWith("*") || s.StartsWith("/*")) return null;
                if (s == "..." || s == "// ...") return null;
                s = TrailingComment.Replace(s, "");
                s = Spaces.Replace(s, " ").Trim();
                if (Punctuation.IsMatch(s)) return null;
                return s;
            }
        }
    }

    /// <summary>Walks up from the test assembly until it finds the solution file.</summary>
    internal static class RepoRoot
    {
        public static string Find()
        {
            // CodeBase, not Location: the net48 runner shadow-copies the assembly to a temp folder.
            string dir = Path.GetDirectoryName(new Uri(typeof(RepoRoot).Assembly.CodeBase).LocalPath);
            while (dir != null && !File.Exists(Path.Combine(dir, "MMP.AsyncProxy.slnx"))) dir = Path.GetDirectoryName(dir);
            if (dir == null) throw new InvalidOperationException("MMP.AsyncProxy.slnx not found above the test assembly");
            return dir;
        }
    }
}
